require_relative './contract'
require_relative './article_paragraph'
require 'nokogiri'

class Article  
  attr_reader :document, :url, :contract_generator

  def initialize(document: '', url: '', contract_generator: Contract)
    @document = Nokogiri::HTML(document)
    @url = url
    @contract_generator = contract_generator
  end

  def self.naics_code
    /\(?(?<code>[0-9]{6,6}+)\)?/
  end

  def self.classification_match
    /\(?(?<code>[A-Za-z0-9 ]+)\)?--/
  end

  def self.amount_math
    /\(?(?<amount>[0-9.,]+)\)?/
  end

  def date
    text = document.css('time').first.text
    potential_date_string = text.match(Article.date_matcher)
    if potential_date_string
      Date.parse(potential_date_string['date']).strftime('%Y-%-m-%-d')
    else
      ''
    end
  end

  def save(database, logger)
    begin
      solicitation_number = database.escape(contract.solicitation_number)
      begin
        contract_award_date = database.escape(Date.parse(contract.contract_award_date).to_s)
      rescue
        contract_award_date = nil
      end
      contract_award_number = database.escape(contract.contract_award_number)
      # contract_dollar_amount
      amount = contract.contract_dollar_amount.match(Article.amount_math)['amount'].scan(/[.0-9]/).join().to_f
      contractor_name = database.escape(contract.contractor_awarded_name)
      duns = database.escape(contract.contractor_awarded_dunus)
      contractor_address = database.escape(contract.contractor_awarded_address)
      synopsis = database.escape(contract.synopsis)
      begin
        posted_date = database.escape(Date.parse(contract.posted_date).to_s)
      rescue
        posted_date = nil
      end
      begin
        response_date = database.escape(Date.parse(contract.response_date).to_s)
      rescue
        response_date = nil
      end
      set_aside = database.escape(contract.set_aside)
      classification_code = database.escape(contract.classification_code.match(Article.classification_match)['code'])
      naics_code = database.escape(contract.naics_code.match(Article.naics_code)['code'])
      site_url = "https://www.fbo.gov/index.php#{url}"
      query = "INSERT INTO fbo_awards (solicitation_number, contract_award_date, contract_award_number, amount, contractor_name, duns, contractor_address, synopsis, posted_date, response_date, set_aside, classification_code, naics_code, url) VALUES ('#{solicitation_number}', '#{contract_award_date}', '#{contract_award_number}', '#{amount}', '#{contractor_name}', '#{duns}', '#{contractor_address}', '#{synopsis}', '#{posted_date}', '#{response_date}', '#{set_aside}','#{classification_code}', '#{naics_code}', '#{site_url}');"
      database.query(query)

    rescue => exception
      logger.log("#{Time.now} ********************** \n")
      logger.log("#{exception}\n")
      logger.log("#{exception.backtrace}\n")
      logger.log("#{contract.to_s}\n")
      logger.log("#{Time.now} ********************** \n")
    end
  end

  def contract
    contract_generator.new(document)
  end
end
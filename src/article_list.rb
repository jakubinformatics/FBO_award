require_relative './dod_service'
require_relative './article'
class ArticleList  
  attr_reader :document, :service, :article_generator

  def initialize(document, service=DODService.new, article_generator=Article)
    @document = Nokogiri::HTML(document)
    @service = service
    @article_generator = article_generator
  end

  def self.article_id_matcher
    /s=opportunity&mode=form&id=(?<id>[a-z,1-9])/
  end

  def identifiers
    document.css('tr.lst-rw')
      .map do |line|
        if line.css('a.lst-lnk-notice')[0]['class'] == 'lst-lnk-notice' and line.css("td[headers='lh_base_type']")[0].text().include?('Award')
          puts line.css('a.lst-lnk-notice')[0][:href]
          ArticleIdentifier.new(line.css('a.lst-lnk-notice')[0][:href])
        else
          nil
        end
      end
      .compact
  end
  
  def get_latest_article
    article_generator.new(document: service.get_article(identifiers.first.param), url: identifiers.first.param)
  end

  def get_all_articles
    identifiers.map do |identifier|
      article_generator.new(document: service.get_article(identifier.param), url: identifier.param)
    end
  end
end


class ArticleIdentifier
  attr_reader :param

  def initialize(param)
    @param = param
  end
end
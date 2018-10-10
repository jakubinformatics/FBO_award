require 'date'

class Contract
  attr_reader :document

  def initialize(document)
    @document = document
  end

  def solicitation_number
    find_content_with('dnf_class_values_procurement_notice__solicitation_number__widget')
  end

  def notice_type
    find_content_with('dnf_class_values_procurement_notice__procurement_type__widget')
  end

  def contract_award_date
    find_content_with('dnf_class_values_procurement_notice__contract_award_date__widget')
  end

  def contract_award_number
    find_content_with('dnf_class_values_procurement_notice__contract_award_number__widget')
  end

  def contract_dollar_amount
    find_content_with('dnf_class_values_procurement_notice__contract_award_amount__widget')
  end

  def synopsis
    find_content_with('dnf_class_values_procurement_notice__description__widget')
  end

  def contractor_awarded_dunus
    find_content_with('dnf_class_values_procurement_notice__contractor_awarded_duns__widget')
  end

  def contractor_awarded_name
    return find_content_with('dnf_class_values_procurement_notice__contractor_awarded_name__widget') unless find_content_with('dnf_class_values_procurement_notice__contractor_awarded_name__widget').empty?
    return find_content_with('dnf_class_values_procurement_notice__contractor_awardee_text__widget') unless find_content_with('dnf_class_values_procurement_notice__contractor_awardee_text__widget').empty?
  end

  def contractor_awarded_address
    find_content_with('dnf_class_values_procurement_notice__contractor_awarded_address__widget')
  end

  def posted_date
    find_content_with('dnf_class_values_procurement_notice__posted_date__widget')
  end

  def response_date
    find_content_with('dnf_class_values_procurement_notice__response_deadline__widget')
  end

  def original_set_aside
    find_content_with('dnf_class_values_procurement_notice__original_set_aside__widget')
  end

  def set_aside
    find_content_with('dnf_class_values_procurement_notice__set_aside__widget')
  end

  def classification_code
    find_content_with('dnf_class_values_procurement_notice__classification_code__widget')
  end

  def naics_code
    find_content_with('dnf_class_values_procurement_notice__naics_code__widget')
  end

  def title
    document.css("div.agency-header").css('h2').text().strip
  end

  def agency
    agent_body[0]
  end

  def office
    agent_body[1]
  end

  def location
    agent_body[2]
  end

  private
  def find_content_with(matcher)
    document.css("div##{matcher}").text().strip
  end

  def agent_body
    doc = document.css("div.agency-name")
    doc.search('br').each do |n|
      n.replace("\n")
    end
    doc.text.split("\n")
  end
end

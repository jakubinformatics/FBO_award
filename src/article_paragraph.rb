class ArticleParagraph
  attr_reader :text
  
  def initialize(text)
    @text = text
  end

  def self.for(text)
    case text
    when ignore_matcher
      IgnoreParagraph
    when contract_text_matcher
      ContractParagraph
    when bureau_matcher
      BureauParagraph
    else
      ArticleParagraph
    end.new(text)
  end

  def self.ignore_matcher
    /(^CONTRACTS$)/
  end

  def self.bureau_matcher
    /^[A-Z.\s]+$/
  end

  def self.contract_text_matcher
    /awarded|\$\d+/
  end

  def ignore?
    false
  end

  def bureau?
    false
  end

  def contract?
    false
  end
end

class ContractParagraph < ArticleParagraph
  def contract?
    true
  end
end

class BureauParagraph < ArticleParagraph
  def bureau?
    true
  end
end

class IgnoreParagraph < ArticleParagraph
  def ignore?
    true
  end
end
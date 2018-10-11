require_relative './dod_service'
require_relative './article_list'
require_relative './article'
require_relative './logger'

class DODAwardFeed
  attr_reader :service, :article_list_generator, :document, :article_list, :article_generator, :article
  
  def initialize(service:DODService.new, article_list_generator:ArticleList, article_generator:Article)
    @service = service
    @article_list_generator = article_list_generator
    @article_generator = article_generator
  end

  def prepare_article_list
    document = service.get_article_list
    @article_list = article_list_generator.new(document, service)
  end

  def prepare_article_list_by_page(page, database, logger, date=nil)
    document = service.get_article_list_by_page(page)
    @article_list = article_list_generator.new(document, service)
    articles = article_list.get_all_articles(date)
    articles.each do |article|
      article.save(database, logger)
    end
  end

  def prepare_latest_article
    prepare_article_list if article_list.nil?
    @article = article_list.get_latest_article
  end

  def prepare_article_published_on(date_string)
    # prepare_article_list if article_list.nil?
    # @article = article_list.get_article_published_on(date_string)
  end

  def save_contracts(database, logger=Logger.new('error.log'))
    article.save(database, logger)
  end
end
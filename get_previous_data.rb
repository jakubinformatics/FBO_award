require_relative './src/dod_award_feed'
require_relative './src/logger'
require 'mysql2'
require 'dotenv/load'

database = Mysql2::Client.new(
  :host => ENV['DB_HOST'], 
  :username => ENV['DB_USERNAME'],
  :database => ENV['DB_DATABASE'],
  :password => ENV['DB_PASSWORD']
)

logger = Logger.new('past_data.log')

1.upto(20).each do |page|
  feed = DODAwardFeed.new
  feed.prepare_article_list_by_page(page, database, logger)
end
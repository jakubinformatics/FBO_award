require_relative '../src/dod_award_feed'

describe 'the DODAwardFeed program' do
  before(:each) do
    @service = double()
    @dod_award_feed = DODAwardFeed.new(service:@service)
  end

  it 'can request and build an article list that can supply ids' do
    returned_document = File.open(File.join(__dir__, './examples/contract_links.txt'))
    expect(@service).to receive(:get_article_list).and_return(returned_document)
    @dod_award_feed.prepare_article_list
    
    expect(@dod_award_feed.article_list.identifiers.length).to eq(30)
  end

  it 'can use the ids of an article list to request and build an article' do
    contract_links = File.open(File.join(__dir__, './examples/contract_links.txt'))
    expect(@service).to receive(:get_article_list).and_return(contract_links)
    @dod_award_feed.prepare_article_list
    article_ids = @dod_award_feed.article_list.identifiers

    returned_document = File.open(File.join(__dir__, './examples/articles/article.txt'))
    expect(@service).to receive(:get_article).with(article_ids.first.id).and_return(returned_document)
    @dod_award_feed.prepare_latest_article
  end

  it 'can use the ids of an article list to request and build an article by date' do
    returned_document = File.open(File.join(__dir__, './examples/contract_links.txt'))
    expect(@service).to receive(:get_article_list).and_return(returned_document)
    expect(@service).to receive(:get_article).with('1331599')

    @dod_award_feed.prepare_article_list
    @dod_award_feed.prepare_article_published_on('Oct. 2, 2017')
  end

  
  it 'should use a database client to determine whether its contents should be saved' do
    class ArticleTestDouble
      def date
        '2017-10-31'
      end
    end
    
    database = double()
    allow(database).to receive(:query).and_return(['contract', 'contract', 'contract'], [])
    
    expect(@dod_award_feed).to receive(:article).twice.and_return ArticleTestDouble.new 
    expect(@dod_award_feed.should_persist?(database)).to eq(false)
    expect(@dod_award_feed.should_persist?(database)).to eq(true)
  end
  
  it 'can request a database client save contracts' do
    database = double()
    article = Article.new
    allow(database).to receive(:escape).and_return 'escaped string'
    allow(@dod_award_feed).to receive(:article).once.and_return article
    
    expect(article).to receive(:contracts).once.and_return([PersistableContractTestDouble.new, PersistableContractTestDouble.new ])
    expect(database).to receive(:query).exactly(2).times
    @dod_award_feed.save_contracts(database)
  end
  
  it 'can log errors encountered while attempting to save contracts' do
    database = double()
    article = Article.new
    logger = double()
    allow(database).to receive(:escape).and_return 'escaped string'
    allow(@dod_award_feed).to receive(:article).once.and_return article
    
    expect(article).to receive(:contracts).once.and_return([PersistableContractTestDouble.new])
    expect(database).to receive(:query).and_throw(:message, "SQL ERROR")
    expect(logger).to receive(:log).at_least(1)
    @dod_award_feed.save_contracts(database, logger)
  end
end


class PersistableContractTestDouble
  def multiple_award?
    false
  end
  
  def award_date
    '2017-10-31'
  end

  def all_text
    'All of the text'
  end

  def vendor_name
    'Charlie Inc'
  end

  def bureau
    'CIA'
  end

  def contract_number
    'HQ-267-123'
  end

  def mod_number
    ''
  end

  def end_date
    '2020-1-4'
  end

  def potential_value
    1000000
  end

  def obligation
    1000
  end

  def competition
    ''
  end

  def order_on_previously_issued
    ''
  end

end
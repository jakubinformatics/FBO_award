require_relative '../src/article_list'

describe 'a DOD article list' do
  before(:each) do
    page = File.open(File.join(__dir__, './examples/contract_links.txt'))
    @article_list = ArticleList.new(page)
  end

  it 'can return ids to contract articles' do
    expect(@article_list.identifiers.count).to eq(30)
    @article_list.identifiers.each do |article_id|
      expect(article_id.id).to match(/^\d+$/)
    end
  end
end
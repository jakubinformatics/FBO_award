require_relative '../src/article'

class ContractTestDouble
  attr_reader :award_date, :bureau

  def initialize(text: '', date:'', bureau:'')
    @award_date = date
    @bureau = bureau
  end
end

describe 'a DOD article' do
  before(:all) do 
    article = File.open(File.join(__dir__, './examples/articles/article.txt'))
    @article = Article.new(document: article, contract_generator:ContractTestDouble)
  end

  it 'can return the appropriate date' do
    expect(@article.date).to eq('2017-10-20')
  end

  it 'can return a list of contracts' do
    expect(@article.contracts.count).to eq(7)
  end

  it 'can pass the correct award_date to contract' do
    @article.contracts.each do |contract|
      expect(contract.award_date).to eq('2017-10-20')
    end
  end
  
  it 'can attach the correct bureau to a contract' do
    air_force_contracts = @article.contracts[0...3]
    air_force_contracts.each do |contract|
      expect(contract.bureau).to eq('AIR FORCE')
    end

    defense_information_systems_agency_contract = @article.contracts[3]
    expect(defense_information_systems_agency_contract.bureau).to eq('DEFENSE INFORMATION SYSTEMS AGENCY')

    defense_logistic_agency_contracts = @article.contracts[4...7]
    defense_logistic_agency_contracts.each do |contract|
      expect(contract.bureau).to eq('DEFENSE LOGISTICS AGENCY')
    end
  end
end
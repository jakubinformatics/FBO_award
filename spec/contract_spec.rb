require_relative '../src/contract'
require 'json'

describe 'a DOD contract' do
  before(:all) do 
    json_file = File.read(File.join(__dir__,'./examples/contracts.json'))
    @contracts = JSON.parse(json_file)
  end

  it 'can return the award date' do
    expect(Contract.new(text: 'text', date: '2017-10-20').award_date).to eq('2017-10-20')
  end

  it 'can return the bureau' do
    expect(Contract.new(text: 'text', date: 'Oct. 20, 2017', bureau: 'NAVY').bureau).to eq('NAVY')
  end
  
  it 'can return the relevant attributes' do 
    @contracts.each do |example_contract|
      c = Contract.new(text: example_contract['all_text'], date: 'Jan. 1, 2017', bureau: '')

      expect(c.vendor_name).to eq(example_contract['vendor_name'])
      expect(c.contract_number).to eq(example_contract['contract_number'])
      expect(c.mod_number).to eq(example_contract['mod_number'])
      expect(c.end_date).to eq(example_contract['end_date'])
      expect(c.potential_value).to eq(example_contract['potential_value'])
      expect(c.obligation).to eq(example_contract['obligation'])
      expect(c.competition).to eq(example_contract['competition'])
      expect(c.order_on_previously_issued).to eq(example_contract['order_on_previously_issued'])
      expect(c.all_text).to eq(example_contract['all_text'])
    end
  end
  
  it 'can skip multiple-award contracts' do
    json_file = File.read(File.join(__dir__,'./examples/multiples.json'))
    multiples = JSON.parse(json_file)
    multiples.each do |multiple|
      expect(Contract.new(text: multiple['all_text'], date: 'Jan. 1, 2017').multiple_award?).to be(true)
    end
  end
end
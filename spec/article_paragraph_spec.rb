require_relative '../src/article_paragraph'

describe 'a DOD article paragraph' do
  before(:all) do 
    @contract_text = "Aermor LLC, Virginia Beach, Virginia; American Systems Corp., Chantilly, Virginia; and Qualis Corp., Huntsville, Alabama, have been awarded a $93,500,000 indefinite-delivery/indefinite-quantity contract for Air Force Operational Test and Evaluation Center test services.  The contractors will provide advisory and assistance services in support of operational test and evaluation that include a broad range of engineering, technical, and analytical services.  Work will be performed at Kirtland Air Force Base, New Mexico; Buckley Air Force Base, Colorado; Edwards Air Force Base, California; Eglin Air Force Base, Florida; Everett, Washington; Hill Air Force Base, Utah; Hurlburt Field, Florida; Nellis Air Force Base, Nevada; and Peterson Air Force Base, Colorado, and is expected to be complete by Oct. 19, 2022.  This award is the result of a competitive acquisition with three offers received.  Fiscal 2018 research, development, test and evaluation; and operations and maintenance funds in the amount of $30,000 are being obligated at the time of award.  Air Force Operational Test and Evaluation Center, Kirtland Air Force Base, New Mexico, is the contracting activity (FA7046-18-D-0001, FA7046-18-D-0002, FA7046-18-D-0003)."
  end
  it 'can identify paragraphs that should be ignored' do
    expect(ArticleParagraph.for('CONTRACTS').ignore?).to eq(true)
    expect(ArticleParagraph.for('AIR FORCE').ignore?).to eq(false)
    expect(ArticleParagraph.for(@contract_text).ignore?).to eq(false)
  end

  it 'can identify a bureau' do
    expect(ArticleParagraph.for('AIR FORCE').bureau?).to eq(true)
    expect(ArticleParagraph.for('NAVY').bureau?).to eq(true)
    expect(ArticleParagraph.for('CONTRACTS').bureau?).to eq(false)
    expect(ArticleParagraph.for(@contract_text).bureau?).to eq(false)
  end

  it 'can identify a contract' do
    expect(ArticleParagraph.for(@contract_text).contract?).to eq(true)
    expect(ArticleParagraph.for('AIR FORCE').contract?).to eq(false)
    expect(ArticleParagraph.for('CONTRACTS').contract?).to eq(false)
  end
end
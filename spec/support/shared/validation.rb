RSpec.shared_examples 'a valid' do
  it 'returns true on validation test' do
    expect(instance.valid?).to be_truthy
  end
end

RSpec.shared_examples 'an invalid' do
  it 'returns false on validation test' do
    expect(instance.valid?).to be_falsey
  end
end

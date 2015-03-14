RSpec.shared_examples 'persistable' do
  it 'raises no error on persisting' do
    expect { instance.save! validation: false }.to_not raise_error
  end
end

RSpec.shared_examples 'not persistable' do |error|
  it 'raises #{error} on persisting' do
    expect { instance.save!(validate: false) }.to raise_error error
  end
end

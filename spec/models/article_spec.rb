require 'rails_helper'

RSpec.describe Article, type: :model do
  context 'with empty body' do
    it 'is not valid' do
      expect(build(:article, body: '').valid?).to be_falsey
    end
  end

  context 'with omitted body' do
    it 'is not persistable' do
      expect { build(:article, body: nil).save! validate: false }.to raise_error ActiveRecord::StatementInvalid
    end
  end

  context 'with properly filled fields' do
    it 'is valid' do
      expect(build(:article).valid?).to be_truthy
    end

    it 'is persistable' do
      expect { create :article }.to_not raise_error
    end
  end
end

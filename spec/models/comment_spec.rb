require 'rails_helper'
require 'support/shared/validation'
require 'support/shared/persisting'

RSpec.describe Comment, type: :model do
  context 'with empty body' do
    let(:instance) { build :comment, body: '' }

    it_behaves_like 'an invalid'
  end

  context 'with omitted body' do
    let(:instance) { build :comment, body: nil }

    it_behaves_like 'not persistable', ActiveRecord::StatementInvalid
  end

  context 'with omitted article' do
    let(:instance) { build :comment, article: nil }

    it_behaves_like 'an invalid'
    it_behaves_like 'not persistable', ActiveRecord::StatementInvalid
  end

  context 'with omitted author' do
    let(:instance) { build :comment, author: nil }

    it_behaves_like 'an invalid'
    it_behaves_like 'persistable'
  end

  context 'with properly filled fields' do
    let(:instance) { build :comment }

    it_behaves_like 'a valid'
    it_behaves_like 'persistable'
  end
end

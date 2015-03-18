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

    context 'was persisted' do
      before(:each) { instance.save! }

      context 'another comment is reply for the first one' do
        let(:reply) { create :comment, article: instance.article, replied_to: instance }
        before(:each) { reply }

        it 'should have replies containg the last comment' do
          expect(instance.replies).to match_array [reply]
        end

        it 'should be replied_to object of its replies' do
          expect(instance.equal? instance.replies.first.replied_to).to be_truthy
        end
      end
    end
  end
end

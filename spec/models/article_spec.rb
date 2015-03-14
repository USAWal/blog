require 'rails_helper'
require 'support/shared/validation'
require 'support/shared/persisting'

RSpec.describe Article, type: :model do
  context 'with empty title' do
    let(:instance) { build :article, title: '' }

    it_behaves_like 'an invalid'
  end

  context 'with omitted title' do
    let(:instance) { build :article, title: nil }

    it_behaves_like 'not persistable', ActiveRecord::StatementInvalid
  end

  context 'with empty body' do
    let(:instance) { build :article, body: '' }

    it_behaves_like 'an invalid'
  end

  context 'with omitted body' do
    let(:instance) { build :article, body: nil }

    it_behaves_like 'not persistable', ActiveRecord::StatementInvalid
  end

  context 'with some comments' do
    let(:article) { create :commented_article }

    it 'returns all its comments ordered descending by creation time' do
      expect(article.comments).to eq Comment.order(created_at: :desc).all
    end

    it 'should be article object of its comments' do
      expect(article.equal? article.comments.first.article).to be_truthy
    end

    context 'was destroied' do
      before(:each) { article.destroy }

      it 'destroys all its comments' do
        expect(Comment.count).to be_zero
      end
    end
  end

  context 'with properly filled fields' do
    let(:instance) { build :article }

    it_behaves_like 'a valid'
    it_behaves_like 'persistable'
  end
end

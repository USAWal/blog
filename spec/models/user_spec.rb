require 'rails_helper'
require 'support/shared/persisting'

RSpec.describe User, type: :model do
  context 'with omitted subscribed field' do
    let(:instance) { build :user, subscribed: nil }

    it_behaves_like 'not persistable', ActiveRecord::StatementInvalid
  end

  it 'is initially unsibscribed' do
    expect(create(:user).subscribed).to eq false
  end

  context 'with some comments' do
    let(:user) { create :active_user }

    it 'returns all its comments ordered descending by creation time' do
      expect(user.comments).to eq Comment.order(created_at: :desc).all
    end

    it 'should be author object of its comments' do
      expect(user.equal? user.comments.first.author).to be_truthy
    end

    context 'was destroied' do
      before(:each) { user.destroy }

      it 'nullify all its comments' do
        expect(Comment.where(author_id: nil).count).to eq Comment.count
      end
    end
  end
end

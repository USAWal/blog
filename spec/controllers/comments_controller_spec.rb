require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  include Warden::Test::Helpers

  context 'signed in user at the article\'s page' do
    let(:article) { create :article }
    let(:user) { create :subscribed_user }

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      Warden.test_mode!
      login_as(user, :scope => :user)
      visit article_path article
    end
    after(:each) { Warden.test_reset! }

    context 'filled comment\'s form' do
      before(:each) { fill_in 'comment_body', with: 'just another comment' }

      context 'tried to send' do
        before(:each) { click_on 'Send' }

        it 'should be redirected to article\'s page' do
          expect(current_path).to eq article_path(article)
        end
      end

      it 'should create new comment after sending' do
          expect { click_on 'Send' }.to change {Comment.count}.by 1
      end
    end
  end
end

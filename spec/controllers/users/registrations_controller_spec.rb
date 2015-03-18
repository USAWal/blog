require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  include Warden::Test::Helpers

  context 'user tried to unsubscribe' do
    before(:each) { visit unsubscribe_path }

    it 'should be redirected to sign in page' do
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'user is signed in' do
    let(:user) { create :subscribed_user }
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      Warden.test_mode!
      login_as(user, :scope => :user)
    end
    after(:each) { Warden.test_reset! }

    context 'user tried to unsubscribe' do
       before(:each) { visit unsubscribe_path }

      it 'should be redirected to root page' do
        expect(current_path).to eq root_path
      end

      it 'should unsubscribe user' do
        expect(user.subscribed).to be_falsey
      end

      it 'should set notice' do
        expect(page).to have_text 'You have successfully unsubscribed!'
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  context 'user tried to unsubscribe' do
    before(:each) { visit unsubscribe_path }

    it 'should be redirected to sign in page' do
      expect(current_path).to eq new_user_session_path
    end
  end
end

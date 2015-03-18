require 'rails_helper'

RSpec.describe 'articles/index.html.erb', type: [:feature, :controller] do
  include Warden::Test::Helpers

  let(:navbar) { page.find 'nav.navbar.navbar-inverse > .container-fluid' }

  context 'root page was requested' do
    before(:each) { visit root_path }

    it 'contains footer\'s logo' do
      expect(page).to have_selector '.container > .footer > .container > .clearfix > .footer-logo > a > img'
    end

    it 'contains copyright\'s container' do
      expect(page).to have_selector '.container > .footer > .container > .footer-copyright.text-center'
    end

    it 'contains copyright' do
      expect(page).to have_text 'Copyright © 2015 blog.co.uk.All rights reserved.'
    end

    it 'contains navbar\'s home url' do
      expect(navbar).to have_selector '.navbar-header > a.navbar-brand'
    end

    it 'contains link to home into navbar' do
      expect(navbar).to have_link 'blog', root_path
    end

    it 'contains sign in button' do
      expect(navbar.find("#navbar_collapse.collapse.navbar-collapse > a[href=\"#{new_user_session_path}\"] > button.btn.btn-danger.navbar-btn[type=\"button\"]").text).to eq 'Sign in'
    end
  end

  context 'user is signed in' do
    let(:user) { create :confirmed_user }
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      Warden.test_mode!
      login_as(user, :scope => :user)
    end
    after(:each) { Warden.test_reset! }

    context 'root page was requested' do
      before(:each) { visit root_path }

      it 'contains edit user button' do
        expect(navbar.find("#navbar_collapse.collapse.navbar-collapse > a[href=\"#{edit_user_registration_path}\"] > button.btn.btn-danger.navbar-btn[type=\"button\"]").text).to eq 'Edit user'
      end

      it 'contains sign out button' do
        expect(navbar.find("#navbar_collapse.collapse.navbar-collapse > a[href=\"#{destroy_user_session_path}\"] > button.btn.btn-danger.navbar-btn[type=\"button\"]").text).to eq 'Sign out'
      end
    end
  end
end

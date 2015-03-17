require 'rails_helper'

RSpec.describe 'articles/index.html.erb', type: :feature do
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

    let(:navbar) { page.find 'nav.navbar.navbar-inverse > .container-fluid' }

    it 'contains navbar\'s home url' do
      expect(navbar).to have_selector '.navbar-header > a.navbar-brand'
    end

    it 'contains link to home into navbar' do
      expect(navbar).to have_link 'blog', root_path
    end
  end
end

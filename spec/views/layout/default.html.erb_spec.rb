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
  end
end

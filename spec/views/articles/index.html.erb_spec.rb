require 'rails_helper'

RSpec.describe 'articles/index.html.erb', type: :view do
  context 'there are 37 articles' do
    before(:each) { create_list :queued_article, 37 }

    context 'list of articles was requested without params' do
      before(:each) { visit articles_path }

      it 'contains pagination' do
        expect(page).to have_selector 'ul.pagination'
      end
    end
  end
end

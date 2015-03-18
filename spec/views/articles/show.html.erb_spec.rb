require 'rails_helper'

RSpec.describe "articles/show.html.erb", type: :view do
  context 'there\'s an article' do
    let(:content) { page.find '.container > .row > .col-md-8.col-md-offset-2.text-center' }
    before(:each) { create :article }

    context 'articl\'s page was requested' do
      let(:article) { Article.first }
      before(:each) { visit article_path article }

      it 'contains header' do
        expect(content).to have_selector 'h1'
      end

      it 'contains title' do
        expect(content).to have_text article.title
      end

      it 'contains horizontal line' do
        expect(content).to have_selector 'h1 + hr'
      end

      it 'contains html body' do
        expect(page.html).to include article.html_body
      end
    end
  end
end

require 'rails_helper'

RSpec.describe 'articles/index.html.erb', type: :view do
  context 'there are 37 articles' do
    let(:content) { page.find '.container > .row > .col-md-8.col-md-offset-2.text-center' }
    let(:timeline) { page.find '.timeline > dl' }
    before(:each) { create_list :queued_article, 37 }

    context 'list of articles was requested without params' do
      let(:articles) { Article.order(created_at: :desc).first 10 }
      before(:each) { visit articles_path }

      it 'contains pagination' do
        expect(content).to have_selector 'ul.pagination'
      end

      it 'contains timeline' do
        expect(content).to have_selector '.timeline > dl'
      end

      it 'has half of the articles on the right side' do
        expect(timeline).to have_selector 'dd.pos-right.clearfix > .time', count: 5
      end

      it 'has half of the articles on the left side' do
        expect(timeline).to have_selector 'dd.pos-left.clearfix > .time', count: 5
      end

      it 'has times' do
        articles.each do |article|
          expect(timeline).to have_text article.created_at.to_time.strftime '%l:%M %p'
        end
      end

      it 'has circs' do
        expect(timeline).to have_selector '.circ', count: articles.count
      end

      it 'has articles headings' do
        expect(timeline).to have_selector '.events > .events-body > h4.events-heading', count: articles.count
      end

      it 'has articles titles' do
        articles.each do |article|
          expect(timeline).to have_text article.title
        end
      end

      it 'has articles body paragraphs' do
        expect(timeline).to have_selector '.events > .events-body > p', count: articles.count
      end

      it 'has articles html body first 300 symbols text' do
        articles.each do |article|
          expect(timeline).to have_text truncate(article.text_body,  length: 300)
        end
      end

      it 'has dates containers' do
        expect(timeline).to have_selector 'dt', count: articles.map { |article| article.created_at.to_date }.uniq.count
      end

      it 'has dates' do
        articles.map { |article| article.created_at.to_date }.uniq.each do |date|
          expect(timeline).to have_text date
        end
      end
    end
  end
end

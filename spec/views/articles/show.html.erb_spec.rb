require 'rails_helper'

RSpec.describe "articles/show.html.erb", type: :view do
  context 'there\'s an article' do
    let(:content) { page.find '.container > .row > .col-md-8.col-md-offset-2.text-center' }
    before(:each) { create :commented_article }

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

    context 'some replies were created' do
      let(:article) { Article.first }
      before(:each) do
        article.comments.each_with_index do |comment, index|
          create_list :comment, 3, article: article, replied_to: comment if index.odd?
        end
      end

      context 'articl\'s page was requested' do
        let(:comments_list) { content.find '.media-list' }
        before(:each) { visit article_path article }

        it 'should have comments list' do
          expect(content).to have_selector '.media-list'
        end

        it 'should have comments containers' do
          expect(comments_list).to have_selector '.media > .media-body', count: article.comments.count
        end

        it 'should have creation time of all comments' do
          article.comments.each do |comment|
            expect(comments_list).to have_text comment.created_at.to_s
          end
        end

        it 'should have bodies of all comments' do
          article.comments.each do |comment|
            expect(comments_list).to have_text comment.body
          end
        end
      end
    end
  end
end

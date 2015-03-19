require 'rails_helper'

RSpec.describe "articles/show.html.erb", type: :view do
  include Warden::Test::Helpers
  let(:comments_list) { content.find '.media-list' }

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

      context 'user is signed in' do
        let(:user) { create :confirmed_user }
        before(:each) do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          Warden.test_mode!
          login_as(user, :scope => :user)
        end
        after(:each) { Warden.test_reset! }

        context 'articl\'s page was requested' do
          let(:form) { content.find "form[action=\"#{comments_path}\"]" }
          before(:each) { visit article_path article }

          it 'has comment\'s creation form' do
            expect(content).to have_selector "form[action=\"#{comments_path}\"]"
          end

          it 'has comment\'s text area' do
            expect(form).to have_selector 'textarea[name="comment[body]"]'
          end

          it 'has submit button' do
            expect(form).to have_selector 'input[type="submit"]'
          end

          it 'has artile id hidden field' do
            expect(form).to have_selector 'input[type="hidden"][name="comment[article_id]"]'
          end

          it 'has replied to id hidden fieldl' do
            expect(form).to have_selector 'input[type="hidden"][name="comment[replied_to_id]"]'
          end

          it 'has reply buttton for all comments' do
            expect(comments_list).to have_selector '.media > .media-body > button', article.comments.count
          end

          it 'has replied to id for all comments' do
            article.comments.each do |comment|
              expect(comments_list).to have_selector "button[data-replied-to=\"#{comment.id}\"]"
            end
          end

          it 'has comment id for all comments' do
            article.comments.each do |comment|
              expect(comments_list).to have_selector "#comment_#{comment.id}.media"
            end
          end
        end
      end

      context 'articl\'s page was requested' do
        before(:each) { visit article_path article }

        it 'has comments list' do
          expect(content).to have_selector '.media-list'
        end

        it 'has comments containers' do
          expect(comments_list).to have_selector '.media > .media-body', count: article.comments.count
        end

        it 'has creation time of all comments' do
          article.comments.each do |comment|
            expect(comments_list).to have_text comment.created_at.to_s
          end
        end

        it 'has bodies of all comments' do
          article.comments.each do |comment|
            expect(comments_list).to have_text comment.body
          end
        end

        it 'has form' do
          expect(content).to have_selector 'form'
        end

        context 'user tried to reply' do
          before(:each) { click_on 'Send' }

          it 'redirects to sign in page' do
            expect(current_path).to eq new_user_session_path
          end
        end
      end
    end
  end
end

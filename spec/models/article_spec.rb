require 'rails_helper'
require 'support/shared/validation'
require 'support/shared/persisting'

RSpec.describe Article, type: :model do
  context 'with empty title' do
    let(:instance) { build :article, title: '' }

    it_behaves_like 'an invalid'
  end

  context 'with omitted title' do
    let(:instance) { build :article, title: nil }

    it_behaves_like 'not persistable', ActiveRecord::StatementInvalid
  end

  context 'with empty body' do
    let(:instance) { build :article, body: '' }

    it_behaves_like 'an invalid'
  end

  context 'with omitted body' do
    let(:instance) { build :article, body: nil }

    it_behaves_like 'not persistable', ActiveRecord::StatementInvalid
  end

  context 'has 5 comments' do
    let(:article) { create :article }
    before(:each) { create_list :queued_comment, 5, article: article, replied_to: nil }

    context 'second comment has 4 replies' do
      let(:comment) { article.comments.second }
      before(:each) { create_list :queued_comment, 4, article: article, replied_to: comment }

      it 'should return article comments tree' do
        result = article.comments.group_by(&:replied_to)
        result.reject! do |key, value|
          result[key.replied_to][result[key.replied_to].find_index key] = { key => result[key] } if key
        end
        expect(article.comments_tree).to eq result
      end
    end
  end

  context 'with some comments' do
    let(:article) { create :commented_article }

    it 'returns all its comments ordered descending by creation time' do
      expect(article.comments).to eq Comment.order(created_at: :desc).all
    end

    it 'should be article object of its comments' do
      expect(article.equal? article.comments.first.article).to be_truthy
    end

    context 'was destroied' do
      before(:each) { article.destroy }

      it 'destroys all its comments' do
        expect(Comment.count).to be_zero
      end
    end
  end

  context 'there are some unsubscribed users' do
    before(:each) { create_list :user, 3 }

    context 'there are some subscribed users' do
      before(:each) { create_list :subscribed_user, 5 }

      context 'article was created' do
        before(:each) { create :article }

        it 'should delay notification routine' do
          expect(Article.method :notify).to be_delayed Article.first.id
        end

        context 'sidekiq jobs were drained' do
          before(:each) { Sidekiq::Worker.drain_all }

          it 'should deliver emails for all subscribed users' do
            expect(ActionMailer::Base.deliveries.last(5).map { |mail| mail.to[0] }).to match_array User.where(subscribed: true).pluck(:email)
          end

          it 'should deliver notifications' do
            expect(ActionMailer::Base.deliveries.last(5).map &:subject).to eq ["Don't blink new article at blog!"] * 5
          end
        end

        context 'article was destroied' do
          before(:each) { Article.destroy_all }

          it 'performs notifying without errors' do
            expect { Sidekiq::Worker.drain_all }.to_not raise_error
          end
        end
      end
    end
  end

  context 'with properly filled fields' do
    let(:instance) { build :article }

    context 'was persisted' do
      before(:each) { instance.save! }

      it 'should be searchable by friendly id' do
        expect(Article.friendly.find instance.title).to eq Article.find instance.id
      end

      it 'should convert Markdown to html' do
        expect(instance.html_body).to eq <<HTML_BODY
<h1>Heading</h1>

<h2>Sub-heading</h2>

<h3>Another deeper heading</h3>

<p>Paragraphs are separated
by a blank line.</p>

<p>Let 2 spaces at the end of a line to do a<br>
line break</p>

<p>Text attributes <em>italic</em>, <strong>bold</strong>,
<code>monospace</code>, <del>strikethrough</del> .</p>

<p>A <a href="http://example.com">link</a>.</p>

<p>Shopping list:</p>

<ul>
<li>apples</li>
<li>oranges</li>
<li>pears</li>
</ul>

<p>Numbered list:</p>

<ol>
<li>apples</li>
<li>oranges</li>
<li>pears</li>
</ol>

<p>The rain---not the reign---in
Spain.</p>
HTML_BODY
      end
    end

    it_behaves_like 'a valid'
    it_behaves_like 'persistable'
  end
end

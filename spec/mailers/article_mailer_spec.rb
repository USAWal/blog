require "rails_helper"

RSpec.describe ArticleMailer, type: :mailer do
  describe 'notification' do
    let(:article) { create :article }
    let(:user) { create :subscribed_user }
    let(:mail) { ArticleMailer.notification user, article }

    it 'has correct subject' do
      expect(mail.subject).to eq "Don't blink new article at blog!"
    end

    it 'was sent to correct user' do
      expect(mail.to).to match_array [user.email]
    end

    it 'was sent from correct email' do
      expect(mail.from).to match_array ['owner@blog.co.uk']
    end

    it "contains article link in html variety" do
      expect(mail.html_part.body).to have_link 'here', href: article_url(article)
    end

    it "contains unsubscribe link in html variety" do
      expect(mail.html_part.body).to have_link 'Unsubscribe', href: unsubscribe_url(redirect_to: article_url(article))
    end

    it "contains article link in text variety" do
      expect(mail.text_part.body).to include article_url(article)
    end

    it "contains unsubscribe link in text variety" do
      expect(mail.text_part.body).to include unsubscribe_url(redirect_to: article_url(article))
    end
  end
end

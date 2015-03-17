class Article < ActiveRecord::Base
  has_many :comments, -> { order created_at: :desc }, inverse_of: :article, dependent: :destroy

  validates_presence_of :body, :title

  after_create { Article.delay.notify id }

  def self.notify(article_id)
    article = Article.find_by id: article_id
    User.where(subscribed: true).find_each do |user|
      ArticleMailer.notification(user, article).deliver_later
    end if article
  end
end

class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title

  paginates_per 10

  has_many :comments, -> { order created_at: :desc }, inverse_of: :article, dependent: :destroy

  validates_presence_of :body, :title

  after_create { Article.delay.notify id }
  before_create :update_html_body

  def self.notify(article_id)
    article = Article.find_by id: article_id
    User.where(subscribed: true).find_each do |user|
      ArticleMailer.notification(user, article).deliver_later
    end if article
  end

  def comments_tree
    grouped_comments = comments.includes(:replied_to).group_by &:replied_to
    return grouped_comments if grouped_comments.count == 1
    grouped_comments.reject! do |key, value|
      if key
        parent_node = grouped_comments[key.replied_to]
        parent_node[parent_node.find_index key] = { key => grouped_comments[key] }
      end
    end || { nil => {} }
  end

  private

  def update_html_body
    self.html_body = Redcarpet::Markdown.new(Redcarpet::Render::HTML, strikethrough: true).render body.to_s
    self.text_body = Nokogiri::HTML(html_body).text
  end
end

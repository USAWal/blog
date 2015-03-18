class Comment < ActiveRecord::Base
  belongs_to :article,    inverse_of: :comments
  belongs_to :author,     inverse_of: :comments,   class_name: 'User'
  has_many   :replies,    inverse_of: :replied_to, class_name: 'Comment', foreign_key: :replied_to_id
  belongs_to :replied_to, inverse_of: :replies,    class_name: 'Comment'

  validates_presence_of :article, :author, :body

  def self.tree(comments)
    comments.map do |comment|
      [comment, comment.replies.any? ? tree(comment.replies) : []]
    end
  end
end

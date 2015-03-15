class Comment < ActiveRecord::Base
  belongs_to :article, inverse_of: :comments
  belongs_to :author,  inverse_of: :comments, class_name: 'User'

  validates_presence_of :article, :author, :body
end

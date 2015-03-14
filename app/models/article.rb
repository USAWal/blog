class Article < ActiveRecord::Base
  has_many :comments, -> { order created_at: :desc }, inverse_of: :article, dependent: :destroy

  validates_presence_of :body, :title
end

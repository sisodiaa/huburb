# Class for Post
class Post < ApplicationRecord
  belongs_to :page

  validates :title, presence: true
  validates :body, presence: true

  scope :recent_five_posts, (lambda {
    order('pinned DESC', updated_at: :desc)
      .limit(5)
  })
end

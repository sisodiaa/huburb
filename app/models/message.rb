# Model for messages
class Message < ApplicationRecord
  belongs_to :room
  belongs_to :sender, polymorphic: true

  validates :room, presence: true
  validates :sender, presence: true
  validates :content, presence: true
end

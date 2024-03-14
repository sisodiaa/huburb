# Model for Room
class Room < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships,
                   source: :memberable, source_type: 'User'
  has_many :pages, through: :memberships,
                   source: :memberable, source_type: 'Page'
  has_many :messages, inverse_of: :room, dependent: :destroy

  def self.find_room(member1, member2)
    (member1.rooms & member2.rooms).first
  end

  def self.create_room(member1, member2)
    create_room_transaction(associated?(member1, member2)) do
      room = Room.create!
      membership1 = room.memberships.new(memberable: member1)
      membership2 = room.memberships.new(memberable: member2)
      create_memberships(membership1, membership2)
    end
  end

  # Checks if logged in user is Sender or not
  def sender(current_user)
    return users.first if users.include? current_user
    pages.first
  end

  # Determines who is recipient using current_user
  def recipient(current_user)
    return pages.first if users.include? current_user
    users.first
  end

  def self.associated?(member1, member2)
    member1.associated_with?(member2)
  end

  def self.create_memberships(membership1, membership2)
    return membership1.room if membership1.save! && membership2.save!
    raise ActiveRecord::Rollback
  end

  def self.create_room_transaction(flag, &block)
    raise Pundit::NotAuthorizedError if flag
    Room.transaction(&block)
  rescue ActiveRecord::RecordInvalid
    nil
  end

  private_class_method :create_memberships, :associated?,
                       :create_room_transaction
end

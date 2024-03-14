class Profile < ApplicationRecord
  belongs_to :user, inverse_of: :profile
  has_one :avatar, as: :imageable, class_name: 'Picture', dependent: :destroy

  enum gender: [:male, :female]
  self.genders.freeze

  before_save { username.downcase! }

  validates :gender, inclusion: { in: %w(male female) }, allow_nil: false
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :first_name, presence: true
  validates :date_of_birth, presence: true

  def picture_association
    :avatar
  end

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  alias_method :picture, :avatar
  alias_method :build_picture, :build_avatar
end

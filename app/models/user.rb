# User model
class User < ApplicationRecord
  has_one :profile, dependent: :destroy, inverse_of: :user
  has_one :address, as: :locatable, dependent: :destroy
  has_many :pages, foreign_key: 'owner_id', inverse_of: :owner,
                   dependent: :destroy
  has_many :memberships, as: :memberable, dependent: :destroy
  has_many :rooms, through: :memberships
  has_many :messages, as: :sender, dependent: :destroy
  has_many :ad_viewers, foreign_key: 'viewer_id', dependent: :nullify
  has_many :ads, through: :ad_viewers

  delegate :username, to: :profile, allow_nil: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  def avatar_picture
    return profile.avatar.picture.thumb.url if profile_avatar?
    label_picture
  end

  def label_picture
    ActionController::Base.helpers.asset_path("label_#{username[0].upcase}.png")
  end

  def pending?
    profile.nil?
  end

  def chat_handle
    profile.full_name
  end

  def sender_type
    'visitor'
  end

  def associated_with?(page)
    pages.include?(page)
  end

  private

  def profile_avatar?
    profile.avatar.present? && profile.avatar.persisted? && !Rails.env.test?
  end
end

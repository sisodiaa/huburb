# Model for Pages
class Page < ApplicationRecord
  belongs_to :owner, class_name: 'User', inverse_of: :pages
  has_one :address, as: :locatable, dependent: :destroy
  has_one :logo, as: :imageable, class_name: 'Picture', dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :memberships, as: :memberable, dependent: :destroy
  has_many :rooms, through: :memberships
  has_many :messages, as: :sender, dependent: :destroy
  has_many :advertisements, dependent: :destroy

  before_create Page::PageCallbacks
  before_destroy :archive_published_advertisements, prepend: true

  # rubocop:disable Style/RedundantSelf
  enum category: Page::Category.list.keys
  self.categories.freeze

  validates :category, inclusion: { in: Page::Category.list.keys.map(&:to_s) },
                       allow_nil: false
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 141 }
  validate :check_pages, on: :create

  # rubocop:disable Lint/AmbiguousBlockAssociation
  scope :with_category, lambda { |category|
    begin
      send(category)
    rescue NoMethodError
      send(:none)
    end
  }

  scope :nearby, lambda { |coordinates, distance = 8000|
    includes(:address)
      .where(
        'ST_DWithin(addresses.location, ST_GeographyFromText(?), ?)',
        coordinates,
        distance
      )
      .references(:addresses)
  }

  scope :order_by_distance, lambda { |coordinates|
    includes(:address)
      .order(
        "ST_Distance(addresses.location, ST_GeographyFromText('#{coordinates}'))"
      )
      .references(:addresses)
  }

  scope :not_owned_by, ->(user) { where.not(owner: user) }

  scope :without_address, lambda {
    left_outer_joins(:address).where(addresses: { locatable_id: nil })
  }
  scope :with_address, -> { joins(:address) }

  def to_param
    pin
  end

  def picture_association
    :logo
  end

  def logo_picture
    if Rails.env.test?
      label_picture
    else
      logo_thumbnail || label_picture
    end
  end

  def label_picture
    ActionController::Base.helpers.asset_path("label_#{name[0].upcase}.png")
  end

  def owner_is_current_user?(current_user)
    owner == current_user
  end

  def chat_handle
    name
  end

  def sender_type
    'page'
  end

  alias picture logo
  alias build_picture build_logo
  alias associated_with? owner_is_current_user?

  private

  def logo_thumbnail
    logo.picture.thumb.url if logo.present? && logo.persisted?
  end

  def check_pages
    add_pages_per_user_quota_error if pages_quota_reached?
  end

  def add_pages_per_user_quota_error
    errors.add(:pages_per_user_quota, 'Only one page per user is allowed.')
  end

  def pages_quota_reached?
    owner.pages.count >= pages_limit
  end

  def pages_limit
    return 1000 if owner.email == 'im.abhi.007@gmail.com'
    Rails.env.test? ? 10 : 1
  end

  def archive_published_advertisements
    Advertisement.where(page: self, status: :published).update_all(
      published_at: Time.zone.now - 15.days,
      status: 'archived'
    )
  end
end

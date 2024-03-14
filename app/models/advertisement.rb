# Model class for Adevrtisement
class Advertisement < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :page
  has_many :ad_viewers, foreign_key: 'ad_id', dependent: :nullify
  has_many :viewers, through: :ad_viewers

  validates :headline, length: { in: 1..50 }, presence: true
  validates :body, length: { in: 1..140 }, presence: true
  validates :url, presence: true
  validates :duration, inclusion: { in: (1..7), message: 'is invalid' }
  validates :duration, presence: true
  validate :verify_status_published_at_and_expired_at_dates
  validate :published_ad_limit_check

  before_validation { self.url = page_path(page) }
  before_save { self.location = page.address.location }
  before_update { throw(:abort) if ad_archived? || published_duration_changed? }
  before_destroy { throw(:abort) if published? }

  enum status: %i[pending published archived]

  scope :not_owned_by, (
    ->(user) { joins(:page).where.not(pages: { owner_id: user }) }
  )

  scope :nearby, (lambda { |coordinates, distance = 8000|
    includes(:page)
      .where(
        'ST_DWithin(location, ST_GeographyFromText(?), ?)',
        coordinates,
        distance
      )
      .references(:page)
  })

  def expired_at
    return nil if published_at.nil?
    published_at + duration.days
  end

  def publish=(value)
    update_attributes(published_at: Time.zone.now, status: 1) if value
  end

  private

  def ad_archived?
    return false if status_changed?
    archived?
  end

  def published_duration_changed?
    published? && duration_changed?
  end

  def verify_status_published_at_and_expired_at_dates
    return false if status_verified?
    errors.add(:base, :status_invalid, message: 'Status is invalid')
  end

  def status_verified?
    pending_verified? || published_verified? || archived_verified?
  end

  def pending_verified?
    pending? && published_at.nil?
  end

  def published_verified?
    current_time = Time.zone.now
    published? && current_time < expired_at && current_time >= published_at
  end

  def archived_verified?
    archived? && Time.zone.now >= expired_at
  end

  def published_ad_limit_check
    return false if pending? || archived?
    published_ad_limit_error if published_ad_limit_exceeds?
  end

  def published_ad_limit_error
    errors.add(
      :base,
      :published_advertisement_limit,
      message: 'Only one advertisement can be published at a time.'
    )
  end

  def published_ad_limit_exceeds?
    page.advertisements.where(status: :published).count > published_ad_limit
  end

  def published_ad_limit
    # Differentiate between update or create action
    new_record? ? 0 : 1
  end
end

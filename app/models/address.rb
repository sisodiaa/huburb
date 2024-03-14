class Address < ApplicationRecord
  belongs_to :locatable, polymorphic: true

  validates :location, :city, :state, :country, presence: true
  validate :either_line1_or_line2_is_present

  def coordinates
    return self.location.to_param.gsub(/[POINT\(\)]/, "").strip unless self.new_record?
    self.location
  end

  def coordinates=(coordinates)
    self.location = generate_WKT_string coordinates
  end

  def isValid?
    (self.line1.present? || self.line2.present?) && self.city.present? && self.state.present? && self.country.present?
  end

  def form_submission_path
    demo_prefix = Rails.env.production? ? '/demo' : ''
    path = case self.locatable_type
    when 'Page'
      "/pages/#{Page.find(self.locatable_id).pin}/address"
    else
      "/user/address"
    end
    "#{demo_prefix}#{path}"
  end

  private
  def either_line1_or_line2_is_present
    unless self.line1.present? || self.line2.present?
      errors.add(:base, :address_line1_and_line2_blank, message: "Either line1 or line2 of Address must be present")
    end
    false
  end

  def generate_WKT_string coordinates
    "POINT(#{coordinates})"
  end
end

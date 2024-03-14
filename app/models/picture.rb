class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  
  mount_uploader :picture, PictureUploader

  attr_accessor :viewport_x, :viewport_y, :viewport_width, :viewport_height, :viewport_pic_w, :viewport_pic_h

  after_save :crop_avatar

  validate  :picture_size

  private
  def crop_avatar
    picture.recreate_versions! if viewport_x.present?
  end

  def picture_size
    if picture.size > 1.megabytes
      errors.add(:picture, "should be less than or equal to 1MB")
    end
  end
end

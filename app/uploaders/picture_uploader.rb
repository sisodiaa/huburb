# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process :set_content_type

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.test? or Rails.env.cucumber?
    storage NullStorage
  elsif Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  process :scale => [1024, 1024]
  #
  def scale(width, height)
    resize_to_limit(width, height) if size <= 1.megabytes
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process :crop
    process :resize_to_fit => [200, 200]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def crop
    if viewport_data_present?
      resize_to_limit(model.viewport_pic_w.to_i, model.viewport_pic_h.to_i)
      manipulate! do |img|
        x = model.viewport_x.to_i
        y = model.viewport_y.to_i
        width = model.viewport_width.to_i
        height = model.viewport_height.to_i
        img.crop("#{width}x#{height}+#{x}+#{y}")
      end
    end
  end

  private
  def viewport_data_present?
    model.viewport_pic_w.present? && model.viewport_pic_h.present? && 
      model.viewport_width.present? && model.viewport_height.present? && 
      model.viewport_x.present? && model.viewport_y.present?
  end

end

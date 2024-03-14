module PictureAssociation
  extend ActiveSupport::Concern

  private
  def associated_picture(imageable)
    [imageable, imageable.picture || imageable.build_picture]
  end
end

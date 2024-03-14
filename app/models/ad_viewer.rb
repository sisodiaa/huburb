# AdViwer model
class AdViewer < ApplicationRecord
  belongs_to :viewer, class_name: 'User'
  belongs_to :ad, class_name: 'Advertisement'

  def self.views(ads, current_user)
    ads.each do |ad|
      find_or_create_by(ad: ad, viewer: current_user).increment(:view).save
    end
  end

  def self.clicks(ad, current_user)
    find_or_create_by(ad: ad, viewer: current_user).increment(:click).save
  end
end

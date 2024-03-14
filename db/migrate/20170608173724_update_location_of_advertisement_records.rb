class UpdateLocationOfAdvertisementRecords < ActiveRecord::Migration[5.0]
  def change
    Advertisement.all.each do |advertisement|
      advertisement.update_attributes(location: advertisement.page.address.location)
    end
  end
end

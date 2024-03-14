class AddLocationToAdvertisements < ActiveRecord::Migration[5.0]
  def change
    add_column :advertisements, :location, :st_point, geographic: true
    add_index :advertisements, :location, using: :gist
  end
end

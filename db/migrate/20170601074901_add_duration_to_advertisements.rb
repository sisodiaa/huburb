class AddDurationToAdvertisements < ActiveRecord::Migration[5.0]
  def change
    add_column :advertisements, :duration, :integer, default: 1
  end
end

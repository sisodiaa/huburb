class RemoveExpiredAtFromAdvertisements < ActiveRecord::Migration[5.0]
  def change
    remove_column :advertisements, :expired_at, :datetime
  end
end

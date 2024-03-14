class AddDefaultValueToGenderInProfile < ActiveRecord::Migration[5.0]
  def change
    change_column :profiles, :gender, :integer, default: 0
  end
end

class ModifyProfiles < ActiveRecord::Migration[5.0]
  def change
    remove_column :profiles, :short_bio, :string
    remove_column :profiles, :bio, :text
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string
  end
end

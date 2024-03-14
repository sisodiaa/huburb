class AddIndexAndNotNullToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_index :profiles, :username, unique: true
    change_column_null :profiles, :username, false
    change_column_null :profiles, :short_bio, false
    change_column_null :profiles, :gender, false
    change_column_null :profiles, :date_of_birth, false
  end
end

class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.string :username
      t.string :short_bio
      t.text :bio
      t.integer :gender
      t.date :date_of_birth
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

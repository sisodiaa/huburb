class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :pincode
      t.string :city
      t.string :state
      t.string :country
      t.text :line1
      t.text :line2
      t.st_point :location, geographic: true, null: false
      t.references :locatable, polymorphic: true, index: true

      t.timestamps
    end

    add_index :addresses, :location, using: :gist
  end
end

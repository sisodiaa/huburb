class CreateAdvertisements < ActiveRecord::Migration[5.0]
  def change
    create_table :advertisements do |t|
      t.string :headline
      t.string :body
      t.string :url
      t.datetime :published_at
      t.datetime :expired_at
      t.integer :status, default: 0
      t.references :page, foreign_key: true

      t.timestamps
    end
  end
end

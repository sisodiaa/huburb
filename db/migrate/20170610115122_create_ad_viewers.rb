class CreateAdViewers < ActiveRecord::Migration[5.0]
  def change
    create_table :ad_viewers do |t|
      t.integer :view, default: 0
      t.integer :click, default: 0
      t.references :viewer
      t.references :ad, type: :uuid

      t.timestamps
    end

    add_foreign_key :ad_viewers, :users, column: :viewer_id
    add_foreign_key :ad_viewers, :advertisements, column: :ad_id
  end
end

class CreateIndexForAdViewers < ActiveRecord::Migration[5.0]
  def change
    add_index :ad_viewers, [:viewer_id, :ad_id], unique: true
  end
end

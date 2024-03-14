class AddPinnedToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :pinned, :boolean, default: false

    Post.all.each do |post|
      post.update_attributes(pinned: false)
    end
  end
end

class AddIndexOnLikes < ActiveRecord::Migration[5.2]
  def change
    add_index :likes, [:user_id, :comment_id, :artwork_id], unique: true
  end
end

class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.bigint :comment_id
      t.bigint :artwork_id
      t.bigint :user_id, null: false

      t.timestamps
    end

    add_index :likes, :comment_id
    add_index :likes, :artwork_id
    add_index :likes, :user_id
  end
end

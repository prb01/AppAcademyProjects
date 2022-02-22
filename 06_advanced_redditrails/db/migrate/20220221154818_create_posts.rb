class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :url
      t.text :content
      t.bigint :sub_id, null: false
      t.bigint :author_id, null: false

      t.timestamps
    end

    add_index :posts, :sub_id
    add_index :posts, :author_id
  end
end

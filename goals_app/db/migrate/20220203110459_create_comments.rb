class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text    :body, null: false
      t.bigint  :author_id, null: false
      t.string  :type, null: false
      t.bigint  :type_id, null: false

      t.timestamps
    end

    add_index :comments, :author_id
    add_index :comments, :type_id
  end
end

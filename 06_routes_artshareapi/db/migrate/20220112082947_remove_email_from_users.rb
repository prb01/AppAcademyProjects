class RemoveEmailFromUsers < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :email, if_exists: true
  end

  def down
    add_column :users, :email, :string, null: false
    add_index :users, :email, unique: true
  end
end

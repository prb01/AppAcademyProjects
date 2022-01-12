class RemoveUserEmailFromUsers < ActiveRecord::Migration[5.2]
  def up
    remove_column :users, :name, :email, if_exists: true
  end

  def down
    add_column :users, :name, :email, null: false
    add_index :users, :email, unique: true
  end
end

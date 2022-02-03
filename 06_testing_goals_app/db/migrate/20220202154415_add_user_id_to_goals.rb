class AddUserIdToGoals < ActiveRecord::Migration[5.2]
  def change
    add_column :goals, :user_id, :bigint, null: false
    add_index :goals, :user_id
  end
end

class UpdateColumnsInComments < ActiveRecord::Migration[5.2]
  def change
    rename_column :comments, :type, :commentable
    rename_column :comments, :type_id, :commentable_id
  end
end

class UpdateCommetableInComments < ActiveRecord::Migration[5.2]
  def change
    rename_column :comments, :commentable, :commentable_type
  end
end

class ChangeStudioInAlbums < ActiveRecord::Migration[5.2]
  def change
    change_column :albums, :studio, :boolean, :null => true
  end
end

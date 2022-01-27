class AddRegularToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :bonus, :boolean, default: false
  end
end

class RemoveNumVisits < ActiveRecord::Migration[5.2]
  def up
    remove_column(:visits, :num_visits)
  end

  def down
    add_column(:visits, :num_visits, null: false)
  end
end

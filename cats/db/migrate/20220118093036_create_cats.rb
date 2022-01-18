class CreateCats < ActiveRecord::Migration[5.2]
  def change
    create_table :cats do |t|
      t.string :name, null: false
      t.string :sex, null: false, limit: 1
      t.date :birth_date, null: false
      t.string :color, null: false
      t.text :description

      t.timestamps
    end

    add_index :cats, :name
    add_index :cats, :color
  end
end

class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.text :question, null: false
      t.integer :poll_id, null: false

      t.timestamps
    end

    add_index :questions, [:question, :poll_id], unique: true
  end
end

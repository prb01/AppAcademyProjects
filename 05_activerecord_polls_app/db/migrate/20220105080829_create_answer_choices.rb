class CreateAnswerChoices < ActiveRecord::Migration[5.2]
  def change
    create_table :answer_choices do |t|
      t.text :answer_choice, null: false
      t.integer :question_id, null: false

      t.timestamps
    end

    add_index :answer_choices, [:answer_choice, :question_id], unique: true
  end
end

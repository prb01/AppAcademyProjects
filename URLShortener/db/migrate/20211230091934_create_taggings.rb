class CreateTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :taggings do |t|
      t.integer :tag_topic_id, null: false
      t.integer :url_id, null: false

      t.timestamps
    end
  end
end

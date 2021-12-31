class AddIndexToShortenedUrls < ActiveRecord::Migration[5.2]
  def change
    add_index :shortened_urls, [:long_url, :user_id], unique: true
  end
end

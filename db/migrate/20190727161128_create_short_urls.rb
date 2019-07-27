class CreateShortUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :short_urls do |t|
      t.string :base_url
      t.string :original_url
      t.integer :hit_count
      t.string :title

      t.timestamps
    end
  end
end

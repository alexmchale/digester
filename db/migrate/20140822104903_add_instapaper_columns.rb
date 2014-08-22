class AddInstapaperColumns < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.integer :instapaper_bookmark_id
      t.string :instapaper_hash
      t.boolean :body_provided
    end
  end
end

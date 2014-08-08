class AddFeedOptionsToUsers < ActiveRecord::Migration

  def change
    change_table :users do |t|
      t.string :feed_title
      t.text :feed_description
      t.text :feed_image_url
    end
  end

end

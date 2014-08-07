class AddMp3UrlToArticles < ActiveRecord::Migration

  def change
    change_table :articles do |t|
      t.text :mp3_url, default: nil
    end
  end

end

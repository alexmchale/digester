class AddAttributesToArticles < ActiveRecord::Migration

  def change
    change_table :articles do |t|
      t.integer :mp3_duration, default: nil
      t.string  :mp3_mime_type
      t.integer :mp3_file_size, default: nil
    end
  end

end

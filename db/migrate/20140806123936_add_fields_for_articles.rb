class AddFieldsForArticles < ActiveRecord::Migration

  def change
    change_table :articles do |t|
      t.text :title
      t.text :author
      t.datetime :published_at
      t.text :transcript
      t.string :sha256
    end
  end

end

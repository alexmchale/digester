class CreateAddRawHtmlToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :raw_html, :text, null: true, default: nil
  end
end

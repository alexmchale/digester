class AddDeletedColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :deleted_at, :datetime, default: nil
  end
end

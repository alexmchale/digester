class AddBookmarkKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bookmark_key, :string
    User.all.each(&:generate_secret_key).each(&:save!)
  end
end

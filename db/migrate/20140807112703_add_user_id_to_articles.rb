class AddUserIdToArticles < ActiveRecord::Migration

  def change
    change_table :articles do |t|
      t.integer :user_id
    end
  end

end

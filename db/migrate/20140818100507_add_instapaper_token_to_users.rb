class AddInstapaperTokenToUsers < ActiveRecord::Migration

  def change
    change_table :users do |t|
      t.string :instapaper_token
      t.string :instapaper_token_secret
    end
  end

end

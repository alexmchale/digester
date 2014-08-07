class AddSecretKeyToUsers < ActiveRecord::Migration

  def change
    change_table :users do |t|
      t.string :secret_key
    end

    User.find_in_batches do |users|
      users.each do |user|
        user.generate_secret_key!
        user.save!
      end
    end
  end

end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :email
      t.string :password_hash

      t.timestamps
    end
  end
end

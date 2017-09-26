class AddUniqueConstraintToUsersToken < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :api_token, :unique => true
  end
end

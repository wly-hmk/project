class AddUniqueConstraintsToTables < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :email, :unique => true
    add_index :sites, :url, :unique => true
    add_index :pages, [:slug, :site], :unique => true
  end
end

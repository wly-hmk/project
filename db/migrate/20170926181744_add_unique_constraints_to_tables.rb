class AddUniqueConstraintsToTables < ActiveRecord::Migration[5.1]
  def up
    add_index :users, :email, :unique => true
    add_index :sites, :url, :unique => true
    add_index :pages, [:slug, :site_id], :unique => true
  end

end

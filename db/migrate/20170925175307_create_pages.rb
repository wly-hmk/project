class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.references :site, foreign_key: true
      t.string :name
      t.string :slug
      t.integer :order

      t.timestamps
    end
  end
end

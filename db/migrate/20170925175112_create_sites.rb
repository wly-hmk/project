class CreateSites < ActiveRecord::Migration[5.1]
  def change
    create_table :sites do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.string :url
      t.boolean :published

      t.timestamps
    end
  end
end

class CreateElements < ActiveRecord::Migration[5.1]
  def change
    create_table :elements do |t|
      t.references :page, foreign_key: true
      t.string :element
      t.text :element_attributes
      t.text :content
      t.integer :order

      t.timestamps
    end
  end
end

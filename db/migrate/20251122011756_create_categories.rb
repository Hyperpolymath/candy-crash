class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.integer :position

      t.timestamps
    end
    add_index :categories, :slug
  end
end

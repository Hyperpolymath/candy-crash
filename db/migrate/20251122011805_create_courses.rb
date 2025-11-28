# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.references :category, null: false, foreign_key: true
      t.references :instructor, polymorphic: true, null: false
      t.decimal :price
      t.integer :duration_hours
      t.string :level
      t.boolean :published
      t.string :slug

      t.timestamps
    end
    add_index :courses, :slug
  end
end

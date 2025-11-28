# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class CreateLessons < ActiveRecord::Migration[7.1]
  def change
    create_table :lessons do |t|
      t.references :course_module, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.string :lesson_type
      t.integer :position
      t.integer :duration_minutes
      t.boolean :published
      t.string :slug

      t.timestamps
    end
    add_index :lessons, :slug
  end
end

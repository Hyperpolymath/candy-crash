# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :content
      t.text :explanation
      t.integer :difficulty
      t.references :category, null: false, foreign_key: true
      t.string :question_type
      t.integer :points

      t.timestamps
    end
  end
end

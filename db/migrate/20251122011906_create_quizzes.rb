# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class CreateQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :quizzes do |t|
      t.string :title
      t.text :description
      t.references :course, null: false, foreign_key: true
      t.integer :passing_score
      t.integer :time_limit_minutes
      t.string :quiz_type
      t.boolean :published
      t.integer :max_attempts

      t.timestamps
    end
  end
end

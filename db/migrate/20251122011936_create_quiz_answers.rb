# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class CreateQuizAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_answers do |t|
      t.references :quiz_attempt, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :question_option, null: false, foreign_key: true
      t.text :answer_text
      t.boolean :is_correct
      t.decimal :points_earned

      t.timestamps
    end
  end
end

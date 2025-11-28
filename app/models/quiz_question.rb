# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class QuizQuestion < ApplicationRecord
  # Associations
  belongs_to :quiz
  belongs_to :question

  # Validations
  validates :position, numericality: { greater_than: 0 }, allow_nil: true
  validates :question_id, uniqueness: { scope: :quiz_id }

  # Scopes
  default_scope { order(position: :asc) }

  # Callbacks
  before_create :set_position

  private

  def set_position
    self.position ||= (quiz.quiz_questions.maximum(:position) || 0) + 1
  end
end

# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class QuestionOption < ApplicationRecord
  # Associations
  belongs_to :question
  has_many :quiz_answers, dependent: :nullify

  # Validations
  validates :content, presence: true
  validates :position, numericality: { greater_than: 0 }, allow_nil: true

  # Scopes
  default_scope { order(position: :asc) }
  scope :correct, -> { where(is_correct: true) }
  scope :incorrect, -> { where(is_correct: false) }

  # Callbacks
  before_save :ensure_single_correct_answer, if: :is_correct?

  private

  def ensure_single_correct_answer
    # For single-choice questions, ensure only one correct answer
    if question.question_type == 'multiple_choice'
      question.question_options.where.not(id: id).update_all(is_correct: false)
    end
  end
end

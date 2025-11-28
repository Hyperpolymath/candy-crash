# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class QuizAnswer < ApplicationRecord
  # Associations
  belongs_to :quiz_attempt
  belongs_to :question
  belongs_to :question_option, optional: true

  # Callbacks
  before_save :calculate_correctness

  # Validations
  validates :question_id, uniqueness: { scope: :quiz_attempt_id }

  # Instance methods
  def correct?
    is_correct == true
  end

  def incorrect?
    is_correct == false
  end

  private

  def calculate_correctness
    if question_option_id.present?
      # Multiple choice question
      self.is_correct = question_option&.is_correct || false
      self.points_earned = is_correct ? question.points : 0
    elsif answer_text.present?
      # Text question - would need manual grading or comparison logic
      # For now, we'll leave it nil and require manual grading
      self.is_correct = nil
      self.points_earned = 0
    else
      self.is_correct = false
      self.points_earned = 0
    end
  end
end

# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class Quiz < ApplicationRecord
  # Associations
  belongs_to :course
  has_many :quiz_questions, dependent: :destroy
  has_many :questions, through: :quiz_questions
  has_many :quiz_attempts, dependent: :destroy

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 200 }
  validates :passing_score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  validates :time_limit_minutes, numericality: { greater_than: 0 }, allow_nil: true
  validates :quiz_type, inclusion: { in: %w[practice exam module_test final_exam] }, allow_blank: true
  validates :max_attempts, numericality: { greater_than: 0 }, allow_nil: true

  # Callbacks
  after_initialize :set_defaults, if: :new_record?

  # Scopes
  scope :published, -> { where(published: true) }
  scope :by_type, ->(type) { where(quiz_type: type) }

  # Instance methods
  def total_points
    questions.sum(:points)
  end

  def question_count
    questions.count
  end

  def attempts_for(user)
    quiz_attempts.where(user: user)
  end

  def best_attempt_for(user)
    attempts_for(user).order(score: :desc).first
  end

  def can_attempt?(user)
    return true if max_attempts.nil?

    attempts_for(user).count < max_attempts
  end

  def average_score
    quiz_attempts.completed.average(:score) || 0.0
  end

  private

  def set_defaults
    self.quiz_type ||= 'practice'
    self.passing_score ||= 70
    self.published ||= false
  end
end

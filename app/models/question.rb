# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class Question < ApplicationRecord
  # Associations
  belongs_to :category, optional: true
  has_many :question_options, dependent: :destroy
  has_many :quiz_questions, dependent: :destroy
  has_many :quizzes, through: :quiz_questions
  has_many :quiz_answers, dependent: :destroy
  has_one_attached :image

  # Validations
  validates :content, presence: true
  validates :question_type, inclusion: { in: %w[multiple_choice true_false text] }
  validates :difficulty, numericality: { in: 1..5 }, allow_nil: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Callbacks
  after_initialize :set_defaults, if: :new_record?

  # Scopes
  scope :by_difficulty, ->(difficulty) { where(difficulty: difficulty) }
  scope :by_type, ->(type) { where(question_type: type) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }

  # Class methods
  def self.random_sample(count)
    order(Arel.sql('RANDOM()')).limit(count)
  end

  # Instance methods
  def correct_answer
    question_options.find_by(is_correct: true)
  end

  def correct_answers
    question_options.where(is_correct: true)
  end

  def check_answer(selected_option_id)
    question_options.find(selected_option_id).is_correct
  rescue ActiveRecord::RecordNotFound
    false
  end

  private

  def set_defaults
    self.question_type ||= 'multiple_choice'
    self.difficulty ||= 3
    self.points ||= 1
  end
end

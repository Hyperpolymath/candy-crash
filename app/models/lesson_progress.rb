# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class LessonProgress < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :lesson

  # Validations
  validates :user_id, uniqueness: { scope: :lesson_id }
  validates :time_spent_minutes, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Callbacks
  after_save :update_enrollment_progress, if: :saved_change_to_completed?

  # Scopes
  scope :completed, -> { where(completed: true) }
  scope :in_progress, -> { where(completed: false) }

  # Instance methods
  def mark_complete!
    update(completed: true, completed_at: Time.current)
  end

  def mark_incomplete!
    update(completed: false, completed_at: nil)
  end

  def add_time(minutes)
    increment!(:time_spent_minutes, minutes)
  end

  private

  def update_enrollment_progress
    enrollment = user.enrollments.find_by(course: lesson.course)
    enrollment&.update_progress!
  end
end

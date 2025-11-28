# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class Enrollment < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :course

  # Validations
  validates :user_id, uniqueness: { scope: :course_id, message: 'already enrolled in this course' }
  validates :status, inclusion: { in: %w[active completed dropped] }, allow_blank: true
  validates :progress, numericality: { in: 0..100 }, allow_nil: true

  # Callbacks
  before_create :set_defaults
  after_create :create_initial_progress

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :completed, -> { where(status: 'completed') }
  scope :dropped, -> { where(status: 'dropped') }

  # Instance methods
  def update_progress!
    total_lessons = course.lessons.count
    return self.progress = 0 if total_lessons.zero?

    completed_lessons = user.lesson_progresses
                            .joins(:lesson)
                            .where(lessons: { course_module_id: course.course_modules.ids })
                            .where(completed: true)
                            .count

    self.progress = ((completed_lessons.to_f / total_lessons) * 100).round(2)
    check_completion
    save
  end

  def complete!
    update(status: 'completed', completed_at: Time.current, progress: 100)
  end

  private

  def set_defaults
    self.enrolled_at ||= Time.current
    self.status ||= 'active'
    self.progress ||= 0
  end

  def create_initial_progress
    # Create lesson progress records for all course lessons
    course.lessons.each do |lesson|
      LessonProgress.find_or_create_by(user: user, lesson: lesson)
    end
  end

  def check_completion
    complete! if progress >= 100 && status != 'completed'
  end
end

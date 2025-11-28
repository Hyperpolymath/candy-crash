# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class CourseModule < ApplicationRecord
  # Associations
  belongs_to :course
  has_many :lessons, dependent: :destroy

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 200 }
  validates :position, numericality: { greater_than: 0 }, allow_nil: true

  # Scopes
  default_scope { order(position: :asc) }
  scope :published, -> { where(published: true) }

  # Instance methods
  def lesson_count
    lessons.count
  end

  def total_duration
    lessons.sum(:duration_minutes)
  end
end

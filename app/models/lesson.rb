# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class Lesson < ApplicationRecord
  # Associations
  belongs_to :course_module
  has_one :course, through: :course_module
  has_many :lesson_progresses, dependent: :destroy
  has_one_attached :video
  has_many_attached :attachments

  # Callbacks
  before_save :generate_slug

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 200 }
  validates :lesson_type, inclusion: { in: %w[video text quiz interactive] }, allow_blank: true
  validates :position, numericality: { greater_than: 0 }, allow_nil: true
  validates :duration_minutes, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :slug, uniqueness: { scope: :course_module_id }, allow_blank: true

  # Scopes
  default_scope { order(position: :asc) }
  scope :published, -> { where(published: true) }
  scope :by_type, ->(type) { where(lesson_type: type) }

  # Instance methods
  def completed_by?(user)
    lesson_progresses.exists?(user: user, completed: true)
  end

  def progress_for(user)
    lesson_progresses.find_or_create_by(user: user)
  end

  private

  def generate_slug
    self.slug = title.parameterize if title_changed?
  end
end

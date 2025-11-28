# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class Course < ApplicationRecord
  # Associations
  belongs_to :category
  belongs_to :instructor, polymorphic: true
  has_many :course_modules, dependent: :destroy
  has_many :lessons, through: :course_modules
  has_many :quizzes, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :enrolled_students, through: :enrollments, source: :user
  has_one_attached :thumbnail

  # Callbacks
  before_save :generate_slug

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 200 }
  validates :description, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :duration_hours, numericality: { greater_than: 0 }, allow_nil: true
  validates :level, inclusion: { in: %w[beginner intermediate advanced] }, allow_blank: true
  validates :slug, uniqueness: true, allow_blank: true

  # Scopes
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :by_level, ->(level) { where(level: level) }

  # Instance methods
  def total_lessons
    lessons.count
  end

  def enrollment_count
    enrollments.count
  end

  def average_rating
    # Placeholder for future rating system
    0.0
  end

  private

  def generate_slug
    self.slug = title.parameterize if title_changed?
  end
end

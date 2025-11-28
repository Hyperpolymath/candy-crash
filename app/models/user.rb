# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enums
  enum role: { student: 0, instructor: 1, admin: 2 }

  # Associations
  has_one :profile, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :enrolled_courses, through: :enrollments, source: :course
  has_many :lesson_progresses, dependent: :destroy
  has_many :quiz_attempts, dependent: :destroy
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements
  has_many :instructed_courses, class_name: 'Course', as: :instructor, dependent: :nullify

  # Callbacks
  after_create :create_profile
  after_initialize :set_default_role, if: :new_record?

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true

  # Scopes
  scope :students, -> { where(role: :student) }
  scope :instructors, -> { where(role: :instructor) }
  scope :admins, -> { where(role: :admin) }

  # Instance methods
  def full_name
    profile&.full_name || email.split('@').first
  end

  def instructor_or_admin?
    instructor? || admin?
  end

  private

  def set_default_role
    self.role ||= :student
  end

  def create_profile
    build_profile.save
  end
end

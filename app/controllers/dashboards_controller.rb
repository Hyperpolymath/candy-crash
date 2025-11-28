# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def student
    authorize :dashboard, :student?

    @enrollments = current_user.enrollments
                               .includes(course: [:category, :instructor])
                               .active
                               .order(enrolled_at: :desc)

    @recent_attempts = current_user.quiz_attempts
                                   .includes(:quiz)
                                   .order(created_at: :desc)
                                   .limit(5)

    @achievements = current_user.achievements
                                .order('user_achievements.earned_at DESC')
                                .limit(6)

    @total_completed_lessons = current_user.lesson_progresses.completed.count
    @total_quizzes_passed = current_user.quiz_attempts.passed.count
    @total_points = current_user.achievements.sum(:points)
  end

  def instructor
    authorize :dashboard, :instructor?

    @courses = current_user.instructed_courses
                          .includes(:category, :enrollments)
                          .order(created_at: :desc)

    @total_students = Enrollment.where(course_id: @courses.pluck(:id)).distinct.count(:user_id)
    @total_courses = @courses.count
    @recent_enrollments = Enrollment.where(course_id: @courses.pluck(:id))
                                    .includes(:user, :course)
                                    .order(enrolled_at: :desc)
                                    .limit(10)
  end

  def admin
    authorize :dashboard, :admin?

    @total_users = User.count
    @total_students = User.students.count
    @total_instructors = User.instructors.count
    @total_courses = Course.count
    @total_enrollments = Enrollment.count

    @recent_users = User.order(created_at: :desc).limit(10)
    @recent_enrollments = Enrollment.includes(:user, :course)
                                    .order(created_at: :desc)
                                    .limit(10)

    @popular_courses = Course.joins(:enrollments)
                            .group('courses.id')
                            .order('COUNT(enrollments.id) DESC')
                            .limit(5)
  end
end

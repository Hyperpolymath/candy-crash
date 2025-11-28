# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :set_quiz
  before_action :check_enrollment

  def show
    @attempts = current_user.quiz_attempts.where(quiz: @quiz).order(created_at: :desc)
    @best_attempt = @attempts.completed.order(score: :desc).first
    @can_attempt = @quiz.can_attempt?(current_user)
  end

  private

  def set_course
    @course = Course.published.friendly.find(params[:course_id])
  rescue ActiveRecord::RecordNotFound
    @course = Course.published.find(params[:course_id])
  end

  def set_quiz
    @quiz = @course.quizzes.published.find(params[:id])
  end

  def check_enrollment
    unless current_user.enrollments.exists?(course: @course)
      redirect_to @course, alert: 'You must enroll in this course first'
    end
  end
end

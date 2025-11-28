# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class CoursesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_course, only: [:show, :enroll]

  def index
    @q = Course.published.ransack(params[:q])
    @courses = @q.result(distinct: true)
                 .includes(:category, :instructor)
                 .page(params[:page])
                 .per(12)

    @categories = Category.all
  end

  def show
    @enrollment = current_enrollment(@course) if current_user
    @modules = @course.course_modules.includes(:lessons)
    @quizzes = @course.quizzes.published
  end

  def enroll
    if current_user.enrollments.exists?(course: @course)
      redirect_to @course, alert: 'You are already enrolled in this course'
      return
    end

    @enrollment = current_user.enrollments.create(course: @course)

    if @enrollment.persisted?
      redirect_to @course, notice: 'Successfully enrolled in course!'
    else
      redirect_to @course, alert: 'Could not enroll in course'
    end
  end

  private

  def set_course
    @course = Course.published.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @course = Course.published.find(params[:id])
  end
end

class PagesController < ApplicationController
  def home
    @featured_courses = Course.published.limit(6)
    @total_courses = Course.published.count
    @total_students = User.students.count
    @total_achievements = Achievement.count
  end

  def about
    @instructors = User.instructors
  end
end

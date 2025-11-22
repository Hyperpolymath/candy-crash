class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  before_action :set_lesson
  before_action :check_enrollment

  def show
    @progress = current_user.lesson_progresses.find_or_create_by(lesson: @lesson)
    @next_lesson = @lesson.course_module.lessons.where('position > ?', @lesson.position).first
    @previous_lesson = @lesson.course_module.lessons.where('position < ?', @lesson.position).last
  end

  def complete
    @progress = current_user.lesson_progresses.find_or_create_by(lesson: @lesson)
    @progress.mark_complete!

    respond_to do |format|
      format.html { redirect_to course_lesson_path(@course, @lesson), notice: 'Lesson completed!' }
      format.json { render json: { completed: true, progress: @progress } }
    end
  end

  private

  def set_course
    @course = Course.published.friendly.find(params[:course_id])
  rescue ActiveRecord::RecordNotFound
    @course = Course.published.find(params[:course_id])
  end

  def set_lesson
    @lesson = @course.lessons.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    @lesson = @course.lessons.find(params[:id])
  end

  def check_enrollment
    unless current_user.enrollments.exists?(course: @course)
      redirect_to @course, alert: 'You must enroll in this course first'
    end
  end
end

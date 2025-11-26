class QuizAttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course_and_quiz
  before_action :check_enrollment
  before_action :set_attempt, only: [:show, :submit_answer, :complete]

  def new
    unless @quiz.can_attempt?(current_user)
      redirect_to course_quiz_path(@course, @quiz), alert: 'You have reached the maximum number of attempts'
      return
    end

    @attempt = current_user.quiz_attempts.create!(quiz: @quiz)
    redirect_to course_quiz_quiz_attempt_path(@course, @quiz, @attempt)
  end

  def show
    if @attempt.completed?
      render :result
    else
      @questions = @quiz.questions.includes(:question_options)
      @current_question_index = @attempt.quiz_answers.count
      @current_question = @questions[@current_question_index]

      redirect_to course_quiz_path(@course, @quiz), alert: 'Quiz completed' if @current_question.nil? && @questions.any?
    end
  end

  def submit_answer
    question = Question.find(params[:question_id])
    option_id = params[:question_option_id]

    answer = @attempt.quiz_answers.find_or_initialize_by(question: question)
    answer.question_option_id = option_id if option_id.present?
    answer.answer_text = params[:answer_text] if params[:answer_text].present?
    answer.save!

    # Check if quiz is complete
    if @attempt.quiz_answers.count >= @quiz.questions.count
      @attempt.complete!

      # Award achievements
      AchievementService.check_and_award(current_user)

      redirect_to course_quiz_quiz_attempt_path(@course, @quiz, @attempt), notice: 'Quiz completed!'
    else
      redirect_to course_quiz_quiz_attempt_path(@course, @quiz, @attempt)
    end
  end

  def complete
    @attempt.complete! unless @attempt.completed?
    redirect_to course_quiz_quiz_attempt_path(@course, @quiz, @attempt)
  end

  private

  def set_course_and_quiz
    @course = Course.published.find(params[:course_id])
    @quiz = @course.quizzes.published.find(params[:quiz_id])
  end

  def set_attempt
    @attempt = current_user.quiz_attempts.find(params[:id])
  end

  def check_enrollment
    unless current_user.enrollments.exists?(course: @course)
      redirect_to @course, alert: 'You must enroll in this course first'
    end
  end
end

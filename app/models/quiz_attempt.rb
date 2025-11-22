class QuizAttempt < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :quiz
  has_many :quiz_answers, dependent: :destroy

  # Validations
  validates :started_at, presence: true
  validates :score, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  # Callbacks
  before_create :set_started_at
  after_save :check_pass_status, if: :completed_at?

  # Scopes
  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_progress, -> { where(completed_at: nil) }
  scope :passed, -> { where(passed: true) }
  scope :failed, -> { where(passed: false) }

  # Instance methods
  def complete!
    return if completed?

    calculate_score
    self.completed_at = Time.current
    save
  end

  def completed?
    completed_at.present?
  end

  def in_progress?
    !completed?
  end

  def duration
    return nil unless completed_at && started_at

    ((completed_at - started_at) / 60.0).round(2) # in minutes
  end

  def time_remaining
    return nil unless quiz.time_limit_minutes && started_at

    elapsed = ((Time.current - started_at) / 60.0).ceil
    [quiz.time_limit_minutes - elapsed, 0].max
  end

  def timed_out?
    return false unless quiz.time_limit_minutes

    time_remaining&.zero?
  end

  private

  def set_started_at
    self.started_at ||= Time.current
  end

  def calculate_score
    total_points = quiz.total_points
    return self.score = 0 if total_points.zero?

    earned_points = quiz_answers.sum(:points_earned)
    self.score = ((earned_points / total_points.to_f) * 100).round(2)
  end

  def check_pass_status
    self.passed = score >= (quiz.passing_score || 70)
  end
end

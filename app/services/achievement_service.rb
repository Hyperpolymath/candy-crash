# frozen_string_literal: true

class AchievementService
  # Award achievements based on user actions
  def self.check_and_award(user)
    new(user).check_all
  end

  def initialize(user)
    @user = user
  end

  def check_all
    check_first_lesson
    check_first_quiz
    check_perfect_score
    check_lesson_milestones
    check_quiz_milestones
  end

  private

  attr_reader :user

  # Award "First Steps" achievement for completing first lesson
  def check_first_lesson
    return unless user.lesson_progresses.completed.any?

    achievement = Achievement.find_by(title: 'First Steps')
    return unless achievement

    award_if_new(achievement)
  end

  # Award "Quiz Master" achievement for passing first quiz
  def check_first_quiz
    return unless user.quiz_attempts.passed.any?

    achievement = Achievement.find_by(title: 'Quiz Master')
    return unless achievement

    award_if_new(achievement)
  end

  # Award "Perfect Score" achievement for getting 100% on any quiz
  def check_perfect_score
    return unless user.quiz_attempts.where('score >= ?', 100).any?

    achievement = Achievement.find_by(title: 'Perfect Score')
    return unless achievement

    award_if_new(achievement)
  end

  # Additional milestone achievements based on lesson count
  def check_lesson_milestones
    completed_lessons = user.lesson_progresses.completed.count

    case completed_lessons
    when 10
      award_if_exists_and_new('Lesson Warrior', 'Complete 10 lessons', 'bronze', 50)
    when 25
      award_if_exists_and_new('Knowledge Seeker', 'Complete 25 lessons', 'silver', 100)
    when 50
      award_if_exists_and_new('Master Learner', 'Complete 50 lessons', 'gold', 250)
    end
  end

  # Additional milestone achievements based on quiz performance
  def check_quiz_milestones
    passed_quizzes = user.quiz_attempts.passed.count

    case passed_quizzes
    when 5
      award_if_exists_and_new('Quiz Expert', 'Pass 5 quizzes', 'bronze', 75)
    when 10
      award_if_exists_and_new('Theory Champion', 'Pass 10 quizzes', 'silver', 150)
    when 25
      award_if_exists_and_new('Grand Master', 'Pass 25 quizzes', 'platinum', 500)
    end
  end

  def award_if_new(achievement)
    return if achievement.earned_by?(user)

    achievement.award_to(user)
    Rails.logger.info "🏆 Awarded '#{achievement.title}' to user #{user.id}"
  end

  def award_if_exists_and_new(title, description, badge_type, points)
    achievement = Achievement.find_or_create_by(title: title) do |a|
      a.description = description
      a.badge_type = badge_type
      a.points = points
    end

    award_if_new(achievement)
  end
end

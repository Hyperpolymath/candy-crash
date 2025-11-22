class Achievement < ApplicationRecord
  # Associations
  has_many :user_achievements, dependent: :destroy
  has_many :users, through: :user_achievements
  has_one_attached :badge_image

  # Validations
  validates :title, presence: true, uniqueness: true
  validates :badge_type, inclusion: { in: %w[bronze silver gold platinum] }, allow_blank: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :by_type, ->(type) { where(badge_type: type) }
  scope :by_min_points, ->(points) { where('points >= ?', points) }

  # Instance methods
  def award_to(user)
    user_achievements.find_or_create_by(user: user, earned_at: Time.current)
  end

  def earned_by?(user)
    user_achievements.exists?(user: user)
  end

  def total_earned
    user_achievements.count
  end
end

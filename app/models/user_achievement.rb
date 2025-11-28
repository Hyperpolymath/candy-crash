# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class UserAchievement < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :achievement

  # Validations
  validates :user_id, uniqueness: { scope: :achievement_id }

  # Callbacks
  before_create :set_earned_at

  # Scopes
  scope :recent, -> { order(earned_at: :desc) }

  private

  def set_earned_at
    self.earned_at ||= Time.current
  end
end

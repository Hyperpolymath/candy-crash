# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class Profile < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :first_name, length: { maximum: 50 }
  validates :last_name, length: { maximum: 50 }
  validates :phone, format: { with: /\A[+]?[\d\s\-()]+\z/, allow_blank: true }

  # Instance methods
  def full_name
    [first_name, last_name].compact.join(' ').presence || 'No Name'
  end

  def age
    return nil unless date_of_birth

    ((Time.zone.now - date_of_birth.to_time) / 1.year.seconds).floor
  end
end

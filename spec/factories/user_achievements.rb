# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

FactoryBot.define do
  factory :user_achievement do
    user { nil }
    achievement { nil }
    earned_at { "2025-11-22 01:20:16" }
  end
end

# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

FactoryBot.define do
  factory :quiz_attempt do
    user { nil }
    quiz { nil }
    score { "9.99" }
    started_at { "2025-11-22 01:19:27" }
    completed_at { "2025-11-22 01:19:27" }
    passed { false }
  end
end

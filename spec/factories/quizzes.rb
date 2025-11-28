# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

FactoryBot.define do
  factory :quiz do
    title { "MyString" }
    description { "MyText" }
    course { nil }
    passing_score { 1 }
    time_limit_minutes { 1 }
    quiz_type { "MyString" }
    published { false }
    max_attempts { 1 }
  end
end

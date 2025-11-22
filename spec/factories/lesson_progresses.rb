FactoryBot.define do
  factory :lesson_progress do
    user { nil }
    lesson { nil }
    completed { false }
    completed_at { "2025-11-22 01:19:56" }
    time_spent_minutes { 1 }
  end
end

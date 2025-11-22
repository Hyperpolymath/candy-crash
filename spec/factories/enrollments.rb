FactoryBot.define do
  factory :enrollment do
    user { nil }
    course { nil }
    enrolled_at { "2025-11-22 01:19:47" }
    completed_at { "2025-11-22 01:19:47" }
    progress { 1 }
    status { "MyString" }
  end
end

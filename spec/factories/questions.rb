FactoryBot.define do
  factory :question do
    content { "MyText" }
    explanation { "MyText" }
    difficulty { 1 }
    category { nil }
    question_type { "MyString" }
    points { 1 }
  end
end

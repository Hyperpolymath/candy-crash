FactoryBot.define do
  factory :quiz_question do
    quiz { nil }
    question { nil }
    position { 1 }
  end
end

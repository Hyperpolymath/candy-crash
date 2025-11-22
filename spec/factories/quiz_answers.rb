FactoryBot.define do
  factory :quiz_answer do
    quiz_attempt { nil }
    question { nil }
    question_option { nil }
    answer_text { "MyText" }
    is_correct { false }
    points_earned { "9.99" }
  end
end

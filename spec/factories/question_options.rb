FactoryBot.define do
  factory :question_option do
    question { nil }
    content { "MyString" }
    is_correct { false }
    position { 1 }
  end
end

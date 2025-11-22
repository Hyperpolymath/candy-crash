FactoryBot.define do
  factory :lesson do
    course_module { nil }
    title { "MyString" }
    content { "MyText" }
    lesson_type { "MyString" }
    position { 1 }
    duration_minutes { 1 }
    published { false }
    slug { "MyString" }
  end
end

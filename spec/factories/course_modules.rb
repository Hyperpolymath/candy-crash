FactoryBot.define do
  factory :course_module do
    course { nil }
    title { "MyString" }
    description { "MyText" }
    position { 1 }
    published { false }
  end
end

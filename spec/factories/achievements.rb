FactoryBot.define do
  factory :achievement do
    title { "MyString" }
    description { "MyText" }
    badge_type { "MyString" }
    criteria { "MyText" }
    points { 1 }
  end
end

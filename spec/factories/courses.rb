# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

FactoryBot.define do
  factory :course do
    title { "MyString" }
    description { "MyText" }
    category { nil }
    instructor { nil }
    price { "9.99" }
    duration_hours { 1 }
    level { "MyString" }
    published { false }
    slug { "MyString" }
  end
end

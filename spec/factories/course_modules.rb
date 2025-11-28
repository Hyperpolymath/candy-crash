# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

FactoryBot.define do
  factory :course_module do
    course { nil }
    title { "MyString" }
    description { "MyText" }
    position { 1 }
    published { false }
  end
end

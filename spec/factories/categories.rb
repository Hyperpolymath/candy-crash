# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

FactoryBot.define do
  factory :category do
    name { "MyString" }
    description { "MyText" }
    slug { "MyString" }
    position { 1 }
  end
end

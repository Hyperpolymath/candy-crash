# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

FactoryBot.define do
  factory :question_option do
    question { nil }
    content { "MyString" }
    is_correct { false }
    position { 1 }
  end
end

# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

FactoryBot.define do
  factory :quiz_question do
    quiz { nil }
    question { nil }
    position { 1 }
  end
end

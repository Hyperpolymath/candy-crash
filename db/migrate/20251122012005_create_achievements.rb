# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class CreateAchievements < ActiveRecord::Migration[7.1]
  def change
    create_table :achievements do |t|
      t.string :title
      t.text :description
      t.string :badge_type
      t.text :criteria
      t.integer :points

      t.timestamps
    end
  end
end

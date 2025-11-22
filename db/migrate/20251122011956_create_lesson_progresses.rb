class CreateLessonProgresses < ActiveRecord::Migration[7.1]
  def change
    create_table :lesson_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.boolean :completed
      t.datetime :completed_at
      t.integer :time_spent_minutes

      t.timestamps
    end
  end
end

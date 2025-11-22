class CreateQuizAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_attempts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.decimal :score
      t.datetime :started_at
      t.datetime :completed_at
      t.boolean :passed

      t.timestamps
    end
  end
end

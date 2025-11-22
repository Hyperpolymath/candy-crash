class CreateQuestionOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :question_options do |t|
      t.references :question, null: false, foreign_key: true
      t.string :content
      t.boolean :is_correct
      t.integer :position

      t.timestamps
    end
  end
end

class CreateTestQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :test_questions do |t|
      t.text :question
      t.string :question_type
      t.float :value
      t.belongs_to :test

      t.timestamps
    end
  end
end

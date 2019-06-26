class CreateSurveyQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_questions do |t|
      t.string :question
      t.boolean :required
      t.belongs_to :survey

      t.timestamps
    end
  end
end

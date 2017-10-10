class CreateSurveyAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_answers do |t|
      t.string :answer
      t.belongs_to :survey_question

      t.timestamps
    end
  end
end

class CreateSurveyResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :survey_responses do |t|
      t.belongs_to :user
      t.belongs_to :survey_answer
      t.timestamps
    end
  end
end

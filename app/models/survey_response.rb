class SurveyResponse < ApplicationRecord

  belongs_to :survey_answer
  belongs_to :user

end

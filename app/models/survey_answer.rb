class SurveyAnswer < ApplicationRecord

  belongs_to :survey_question, optional: true

  validates :answer,
            presence: true

end

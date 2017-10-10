class SurveyQuestion < ApplicationRecord

  belongs_to :survey, optional: true
  has_many :survey_answers


  validates :question,
            presence: true

end

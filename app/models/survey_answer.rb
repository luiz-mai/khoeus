class SurveyAnswer < ApplicationRecord
  attr_accessor :chosen_answer

  belongs_to :survey_question, optional: true
  has_many :survey_responses

  validates :answer,
            presence: true

end

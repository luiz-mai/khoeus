class SurveyQuestion < ApplicationRecord

  belongs_to :survey, optional: true
  has_many :survey_answers

  accepts_nested_attributes_for :survey_answers, allow_destroy: true

  validates :question,
            presence: true

end

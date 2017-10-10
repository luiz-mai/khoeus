class Survey < BoardItem

  has_many :survey_questions

  accepts_nested_attributes_for :survey_questions, allow_destroy: true

end

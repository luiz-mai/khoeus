class Survey < BoardItem

  has_many :survey_questions, :dependent => :destroy

  accepts_nested_attributes_for :survey_questions, allow_destroy: true

  validates :end_time,
            presence: true

end

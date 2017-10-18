class Test < BoardItem

  has_many :test_questions, :dependent => :destroy

  accepts_nested_attributes_for :test_questions, allow_destroy: true

  validates :end_time,
            presence: true

end

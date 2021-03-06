class Assignment < BoardItem
  attr_accessor :content
  attr_accessor :assignment_file
  attr_accessor :code
  attr_accessor :code_language
  attr_accessor :grade
  attr_accessor :feedback

  has_many :submissions, :dependent => :destroy
  belongs_to :grade_category

  accepts_nested_attributes_for :submissions, allow_destroy: true

  validates :assignment_type,
            presence: true

  validates :end_time,
            presence: true

end

class Assignment < BoardItem
  attr_accessor :content
  attr_accessor :assignment_file
  attr_accessor :code
  attr_accessor :code_language

  has_many :submissions, :dependent => :destroy

  accepts_nested_attributes_for :submissions, allow_destroy: true

  validates :assignment_type,
            presence: true

  validates :end_time,
            presence: true

  validates :file_limit,
            presence: true

end

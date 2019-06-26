class ExternalActivity < BoardItem
  attr_accessor :grade
  attr_accessor :feedback

  has_many :activities, :dependent => :destroy
  belongs_to :grade_category

end

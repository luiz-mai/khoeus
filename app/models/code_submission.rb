class CodeSubmission < Submission

  has_many :code_lines

  accepts_nested_attributes_for :code_lines, allow_destroy: true

  validates :language,
            presence: true

 end

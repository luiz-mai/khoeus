class CodeSubmission < Submission

  has_many :code_lines

  validates :language,
            presence: true

 end

class CodeLine < ApplicationRecord
  belongs_to :code_submission

  validates_presence_of :line_number

end

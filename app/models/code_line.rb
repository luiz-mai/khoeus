class CodeLine < ApplicationRecord
  attr_accessor :feedback

  belongs_to :code_submission
  has_many :code_line_feedbacks

  accepts_nested_attributes_for :code_line_feedbacks, allow_destroy: true

  validates_presence_of :line_number

end

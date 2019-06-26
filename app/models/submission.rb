class Submission < ApplicationRecord
  attr_accessor :feedback
  attr_accessor :code_line

  belongs_to :user
  belongs_to :assignment
  has_many :text_feedbacks

  has_attached_file :assignment_file

  self.inheritance_column = :type
end

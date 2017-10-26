class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :assignment

  has_attached_file :assignment_file

  self.inheritance_column = :type
end

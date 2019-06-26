class BoardItem < ApplicationRecord
  belongs_to :section

  has_attached_file :document_file

  self.inheritance_column = :type

  validates :title, presence: true
  validates :position, presence: true, numericality: {only_integer: true}

end

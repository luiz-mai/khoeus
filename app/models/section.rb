class Section < ApplicationRecord
  belongs_to :classroom
  has_many :board_items

  validates :title,
            presence: true
  validates :position,
            presence: true

end

class Section < ApplicationRecord
  belongs_to :classroom
  has_many :board_items, :dependent => :destroy

  validates :title,
            presence: true
  validates :position,
            presence: true

end

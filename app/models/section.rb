class Section < ApplicationRecord
  belongs_to :classroom

  validates :title, presence: true
  validates :position, presence: true

end

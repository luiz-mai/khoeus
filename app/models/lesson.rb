class Lesson < ApplicationRecord
  has_many :presences
  belongs_to :classroom
end

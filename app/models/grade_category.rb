class GradeCategory < ApplicationRecord
  belongs_to :classroom
  has_many :tests
  has_many :assignments
  has_many :external_activities

  validates :title,
            presence: true

  validates :weight,
            presence: true
end

class Classroom < ApplicationRecord
  has_secure_password

  has_many :subscriptions
  has_many :users, through: :subscriptions

  validates :name, presence: true
  validates :password, presence: true
  validates :minimum_grade, presence: true, if: :has_grades?

end

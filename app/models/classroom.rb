class Classroom < ApplicationRecord
  has_secure_password

  has_many :subscriptions, :dependent => :destroy
  has_many :users, through: :subscriptions
  has_many :sections, :dependent => :destroy

  validates :name, presence: true
  validates :password, presence: true
  validates :minimum_grade, presence: true, if: :has_grades?

end

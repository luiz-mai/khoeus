class Classroom < ApplicationRecord
  has_secure_password

  has_many :subscriptions, :dependent => :destroy
  has_many :users, through: :subscriptions
  has_many :sections, :dependent => :destroy
  has_many :grade_categories, :dependent => :destroy
  has_many :lessons, :dependent => :destroy

  accepts_nested_attributes_for :grade_categories, allow_destroy: true

  validates :name, presence: true
  validates :password, presence: true
  validates :minimum_grade, presence: true, if: :has_grades?

end

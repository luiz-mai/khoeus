class TestQuestion < ApplicationRecord
  attr_accessor :answer
  attr_accessor :feedback
  attr_accessor :grade

  belongs_to :test, optional: true
  has_many :test_alternatives, :dependent => :destroy
  has_many :test_text_responses, :dependent => :destroy

  accepts_nested_attributes_for :test_alternatives, allow_destroy: true

  validates :question,
            presence: true

  validates :question_type,
            presence: true

  validates :value,
            presence: true
end

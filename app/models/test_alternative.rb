class TestAlternative < ApplicationRecord
  attr_accessor :chosen_alternative

  belongs_to :test_question, optional: true
  has_many :test_alternative_responses

  validates :content,
            presence: true


end

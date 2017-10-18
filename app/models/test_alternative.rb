class TestAlternative < ApplicationRecord
  attr_accessor :chosen_alternative

  belongs_to :test_question, optional: true

  validates :content,
            presence: true


end

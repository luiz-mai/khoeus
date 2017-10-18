class TestAlternativeResponse < ApplicationRecord

  belongs_to :test_alternative
  belongs_to :user
  has_one :text_feedback

end

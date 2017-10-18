class TestTextResponse < ApplicationRecord
  belongs_to :test_question
  belongs_to :user
  has_one :text_feedback

  validates :response,
            presence: true

end

class TextFeedback < ApplicationRecord
  belongs_to :test_alternative_response, optional: true
  belongs_to :test_text_response, optional: true
end

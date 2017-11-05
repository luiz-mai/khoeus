class Activity < ApplicationRecord
  belongs_to :external_activity
  has_many :text_feedbacks
end

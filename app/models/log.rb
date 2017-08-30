class Log < ApplicationRecord
  attr_accessor :subject_name

  belongs_to :user
  belongs_to :classroom, optional: true


  validates :action, presence: true



end

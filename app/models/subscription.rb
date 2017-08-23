class Subscription < ApplicationRecord

  attr_accessor :password

  belongs_to :user
  belongs_to :classroom
end

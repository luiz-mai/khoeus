module SubscriptionsHelper
  include ClassroomsHelper
  include UsersHelper

  def is_teacher?
    Subscription.where(classroom_id: 1, user_id: 1).first.role == 'teacher'
  end
end

module SubscriptionsHelper
  include ClassroomsHelper
  include UsersHelper

  def is_teacher?
    return true if current_user.admin?
    subscription = Subscription.where(classroom_id: current_classroom, user_id: current_user)
    subscription && subscription.first.role == 'teacher'
  end
end

module SubscriptionsHelper
  include ClassroomsHelper
  include UsersHelper

  def is_teacher?
    Subscription.where(classroom_id: current_classroom, user_id: current_user).first.role == 'teacher'
  end
end

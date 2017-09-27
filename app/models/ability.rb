class Ability
  include CanCan::Ability

  def initialize(user, current_classroom = nil)
    can [:new, :create,
         :activate,
         :login, :user_login,
         :password_reset, :send_new_password,
         :choose_password, :reset_password], User
    if user
      if user.admin?
        can :manage, :all
      else
        can [:show, :logout], User
        can [:edit, :update], User, :id => user.id
        can [:index, :show, :members], Classroom
        can [:edit, :update], Classroom do |classroom|
          user.subscriptions.find_by(classroom_id: classroom.id).role == 'teacher'
        end
        can [:new, :create], Subscription
        can [:teacher_index], Log
        if (subscription = user.subscriptions.find_by(classroom_id: current_classroom))
          if subscription.role == 'teacher'
            can [:new, :edit, :create, :update], Section
            can [:new, :edit, :create, :update], Link
            can [:new, :edit, :create, :update], Document
          end
        end
      end
    end


  end
end

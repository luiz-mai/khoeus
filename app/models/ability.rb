class Ability
  include CanCan::Ability

  def initialize(user)
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
        can [:index, :show], Classroom
        can [:edit], Classroom do |classroom|
          user.subscriptions.where(classroom_id: classroom.id).first.role == 'teacher'
        end
        can [:new, :create], Subscription
      end
    end


  end
end

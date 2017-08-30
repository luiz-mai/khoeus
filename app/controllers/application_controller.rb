class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper
  include ClassroomsHelper

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
    else
      redirect_to login_path
    end
  end

  def generate_log(action, subject = nil, subject_id = nil, classroom_id = nil, user_id = nil)
    log = Log.new
    log.action = action
    log.subject = subject if subject
    log.subject_id = subject_id if subject_id
    log.classroom = Classroom.find_by(id: classroom_id) if classroom_id
    log.user = user_id ? User.find_by(id: user_id) : current_user
    ManageLogService.new(log).create
  end

  private

    def current_ability
      @current_ability ||= Ability.new(current_user, params[:classroom_id])
    end
end

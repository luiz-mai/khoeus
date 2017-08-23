class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include UsersHelper

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
    else
      redirect_to login_path
    end
  end
end

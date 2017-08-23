class PagesController < ApplicationController
  include UsersHelper

  def home
    if logged_in?
      redirect_to classrooms_path
    end
  end
end

class SubscriptionsController < ApplicationController
  load_and_authorize_resource

  before_action :set_classroom, only: [:new, :create]
  before_action :visitor_only, only: [:new, :create]

  def new
    @subscription = Subscription.new
  end

  def create
    if @classroom.authenticate(params[:subscription][:password])
      @subscription = Subscription.new(user_id: current_user.id, classroom_id: @classroom.id, role: 'student')
      if ManageSubscriptionService.new(@subscription).create
        redirect_to @subscription.classroom, notice: 'Subscription was successfully created.'
      else
        redirect_to classrooms_url, notice: 'Subscription not created.'
      end
    else
      flash[:danger] = 'Password is wrong.'
      render 'new'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_classroom
    @classroom = Classroom.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def subscription_params
    params.require(:subscription).permit(:password)
  end

  def visitor_only
    if current_user.admin? || current_user.subscriptions.where(classroom_id: @classroom.id).exists?
      redirect_to @classroom
    end
  end

end

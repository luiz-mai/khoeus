class UsersController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_user_by_email, only: [:choose_password, :reset_password]
  before_action :valid_token, only: [:choose_password, :reset_password]
  before_action :check_reset_token_expiration, only: [:choose_password, :reset_password]


  # GET /users
  def index
    @users = User.all
    generate_log('viewed all', 'User')
  end

  # GET /users/1
  def show
    generate_log('viewed', 'User', @user.id)
  end

  # GET /users/new
  def new
    if logged_in?
      redirect_to current_user
    else
      @user = User.new
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.create(user_params)
    if ManageUserService.new(@user).signup
      flash[:info] = 'Please, check your email to activate your account.'
      generate_log('created an account', nil, nil, nil, @user.id)
      redirect_to login_path
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    if ManageUserService.new(@user).edit_profile(user_params)
      flash[:success] = 'Profile updated'
      generate_log('edited his account')
      current_user.admin? ? redirect_to(users_path) : redirect_to(@user)
    else
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    generate_log('deleted', 'User', @user.id)
    ManageUserService.new(@user).delete
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  # GET /activate/1
  def activate
    @user = User.find_by(email: params[:email])
    if @user && !@user.confirmed? && Tokens.digest_match(@user, :activation, params[:token])
      ManageUserService.new(@user).activate
      generate_log('activated his account', nil, nil, nil, @user.id)
      session[:user_id] = @user.id
      flash[:success] = 'Account activated!'
      redirect_to @user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end

  #GET /login
  def login
    if current_user
      redirect_to current_user
    end
  end

  # POST /login
  def user_login
    @user = User.find_by(email: params[:login][:email].downcase)
    if @user && @user.authenticate(params[:login][:password])
      if @user.confirmed?
        session[:user_id] = @user.id
        remember_me = params[:login][:remember_me] == '1'
        ManageUserService.new(@user).login(remember_me)
        if remember_me
          cookies.permanent.signed[:user_id] = @user.id
          cookies.permanent[:remember_token] = @user.remember_token
        else
          cookies.delete(:user_id)
          cookies.delete(:remember_token)
        end
        generate_log('logged in')
        redirect_to classrooms_path
      else
        message  = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash.now[:warning] = message
        render :login
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render :login
    end
  end

  def logout
    if logged_in?
      ManageUserService.new(current_user).forget
      generate_log('logged out')
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
      session.delete(:user_id)
      @current_user = nil
    end
    redirect_to root_url
  end

  def password_reset
  end

  def send_new_password
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      ManageUserService.new(@user).send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      generate_log('requested a password reset', nil, nil, nil, @user.id)
      redirect_to login_path
    else
      flash.now[:danger] = 'Email address not found'
      render :password_reset
    end
  end

  def choose_password
  end

  def reset_password
    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      redirect_to choose_password_path
    elsif @user.update_attributes(user_params)          # Case (4)
      session[:user_id] = @user.id
      generate_log('reseted his password', nil, nil, nil, @user.id)
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render :choose_password
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def set_user_by_email
      @user = User.find_by(email: params[:email])
    end

    def user_params
      params.require(:user).permit(:photo, :name, :email, :password, :password_confirmation, :cep, :address, :number, :complement, :neighborhood, :city, :state, :country, :photo_name, :language, :timezone  )
    end

    def check_reset_token_expiration
      if @user.reset_sent_at < 2.hours.ago
        flash[:danger] = 'Password reset has expired.'
        redirect_to password_reset_url
      end
    end

    def valid_token
      unless @user && @user.confirmed? && @user.authenticated?(:reset, params[:token])
        redirect_to root_url
      end
    end
end
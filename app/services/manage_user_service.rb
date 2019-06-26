class ManageUserService < CrudService
  include Tokens

  def initialize(user = nil)
    if user
      @user = user
      super('User', user)
    else
      super('User')
    end
  end

  def retrieve_by_email(email)
    User.find_by(email: email)
  end

  def create(user_params)
    if (@user = super)
      UserMailer.account_activation(@user).deliver_now
      @user
    else
      false
    end
  end

  def update(user_params)
    @user.update_attributes(user_params)
  end

  def activate
    @user.update_attribute(:confirmed,    true)
    @user.update_attribute(:confirmed_at, Time.zone.now)
  end

  def login(remember_me)
    if remember_me
      @user.remember_token = Tokens.new_token
      @user.update_attribute(:remember_digest, Tokens.digest(@user.remember_token))
    else
      @user.update_attribute(:remember_digest, nil)
    end
  end

  def send_password_reset_email
    @user.reset_token = Tokens.new_token
    @user.update_attribute(:reset_digest,  Tokens.digest(@user.reset_token))
    @user.update_attribute(:reset_sent_at, Time.zone.now)
    UserMailer.password_reset(@user).deliver_now
  end

  def forget
    @user.update_attribute(:remember_digest, nil)
  end
end
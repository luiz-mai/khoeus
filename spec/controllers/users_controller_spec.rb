require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) {create :user}
  let(:other_user) {create :other_user}
  let(:admin_user) {create :admin_user}
  let(:invalid_user) {create :invalid_user}
  let(:unconfirmed_user) {create :unconfirmed_user}
  let(:confirmed_user) {create :confirmed_user}
  let(:expired_token_user) {create :expired_token_user}

  describe 'GET /users' do
    context 'when logged out' do
      it 'redirects to login' do
        get :index
        expect(response).to redirect_to login_url
      end
    end
    context 'when common user' do
      it 'returns status 403' do
        log_in user
        get :index
        expect(response).to have_http_status 403
      end
    end
    context 'when admin user' do
      it 'returns status 200' do
        log_in admin_user
        get :index
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'GET /users/<id>' do
    context 'when logged out' do
      it 'redirects to login' do
        get :show, params: {id: user.id}
        expect(response).to redirect_to login_path
      end
    end
    context 'when logged in' do
      it 'returns status 200' do
        log_in user
        get :show, params: {id: user.id}
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'GET /users/new' do
    context 'when logged out' do
      it 'returns status 200' do
        get :new
        expect(response).to have_http_status 200
      end
    end
    context 'when logged in' do
      it 'redirects to user page' do
        log_in user
        get :new
        expect(response).to redirect_to :action => :show, :id => user.id
      end
    end
  end

  describe 'GET /users/<id>/edit' do
    context 'when logged out' do
      it 'redirects to login page' do
        get :edit, params: {id: user.id}
        expect(response).to redirect_to login_path
      end
    end
    context 'when current user' do
      it 'returns status 200' do
        log_in user
        get :edit, params: {id: user.id}
        expect(response).to have_http_status 200
      end
    end
    context 'when other user' do
      it 'returns status 403' do
        log_in other_user
        get :edit, params: {id: user.id}
        expect(response).to have_http_status 403
      end
    end
  end

  describe 'POST /users' do
    context 'when valid params' do
      it 'creates a new user' do
        expect{
          post :create, params: {user: attributes_for(:user)}
        }.to change(User, :count).by(1)
      end
      it 'redirects to login page' do
        post :create, params: {user: attributes_for(:user, email: 'bbb@xxx.com')}
        expect(response).to redirect_to :login
      end
    end
    context 'when invalid params' do
      it 'returns to signup page' do
        post :create, params: {user: attributes_for(:invalid_user)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT /users/<id>' do
    context 'when unauthorized' do
      it 'returns status 403 to logged out user' do
        #Logged out
        put :update, params: {id: user.id, user: attributes_for(:user, email: 'new_email@gmail.com')}
        expect(response).to redirect_to login_path
      end
      it 'returns status 403 to other user' do
        #Other than current user
        log_in other_user
        put :update, params: {id: user.id, user: attributes_for(:user, email: 'new_email@gmail.com')}
        expect(response).to have_http_status 403
      end
    end
    context 'when authorized with valid params' do
      it 'updates the user to current user' do
        #Current User
        log_in user
        put :update, params: {id: user.id, user: attributes_for(:user, email: 'new_email@gmail.com')}
        user.reload
        expect(user.email).to eq('new_email@gmail.com')
      end
      it 'redirects after update to current user' do
        #Current User
        log_in user
        put :update, params: {id: user.id, user: attributes_for(:user, email: 'new_email@gmail.com')}
        expect(response).to redirect_to user
      end
      it 'updates the user to admin' do
        #Admin User
        log_in admin_user
        put :update, params: {id: user.id, user: attributes_for(:user, email: 'new_email@gmail.com')}
        user.reload
        expect(user.email).to eq('new_email@gmail.com')
      end
      it 'redirects after update to admin' do
        #Admin User
        log_in admin_user
        put :update, params: {id: user.id, user: attributes_for(:user, email: 'new_email@gmail.com')}
        expect(response).to redirect_to users_url
      end
    end
    context 'when authorized with invalid params' do
      it 'returns to edit page to current user' do
        #Current User
        log_in user
        put :update, params: {id: user.id, user: attributes_for(:user, email: 'new_email@gmail')}
        expect(response).to render_template :edit
      end

      it 'returns to edit page to admin' do
        #Admin User
        log_in admin_user
        put :update, params: {id: user.id, user: attributes_for(:user, email: 'new_email@gmail')}
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE /users/<id>' do
    before(:each) { user }  #Don't allow to recreate user
    context 'when logged out' do
      it 'redirects to login path' do
        delete :destroy, params: {id: user.id}
        expect(response).to redirect_to login_path
      end
    end
    context 'when non-admin user' do
      it 'returns status 403' do
        log_in user
        delete :destroy, params: {id: user.id}
        expect(response).to have_http_status 403
      end
    end
    context 'when admin user' do
      it 'deletes the user' do
        log_in admin_user
        expect {
          delete :destroy, params: {id: user.id}
        }.to change(User, :count).by(-1)
      end
      it 'redirects to users list' do
        log_in admin_user
        delete :destroy, params: {id: user.id}
        expect(response).to redirect_to users_path
      end
    end
  end

  describe 'GET /login' do
    context 'when logged in' do
      it 'redirects to user page' do
        log_in user
        get :login
        expect(response).to redirect_to user
      end
    end
    context 'when logged out' do
      it 'returns status 200' do
        get :login
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'POST /login' do
    context 'when wrong params' do
      it 'returns to login page' do
        login = {email: user.email, password: user.password + 'aaa'}
        post :user_login, params: {login: login}
        expect(response).to render_template :login
      end
    end
    context 'when not confirmed' do
      it 'returns to login page' do
        login = {email: unconfirmed_user.email, password: unconfirmed_user.password}
        post :user_login, params: {login: login}
        expect(response).to render_template :login
      end
    end
    context 'when valid and confirmed' do
      it 'redirects to user page' do
        login = {email: confirmed_user.email, password: confirmed_user.password}
        post :user_login, params: {login: login}
        expect(response).to redirect_to classrooms_path
      end
    end
  end

  #DELETE /logout
  describe 'DELETE /logout' do
    context 'when logged in' do
      it 'erases user_id from session' do
        log_in user
        delete :logout
        expect(session[:user_id]).to be_nil
      end
      it 'erases user_id from cookies' do
        log_in user
        delete :logout
        expect(cookies[:user_id]).to be_nil
      end
      it 'redirects to homepage' do
        log_in user
        delete :logout
        expect(response).to redirect_to root_path
      end
    end
    context 'when logged out' do
      it 'redirects to login page' do
        delete :logout
        expect(response).to redirect_to :login
      end
    end
  end

  describe 'POST /password-reset' do
    context 'when email exists' do
      it 'redirects to login page' do
        post :send_new_password, params: {user: {email: user.email}}
        expect(response).to redirect_to :login
      end
    end
    context 'when email doesnt exists' do
      it 'redirects to password reset page' do
        post :send_new_password, params: {user: {email: user.email + 'aaa'}}
        expect(response).to render_template :password_reset
      end
    end
  end

  describe 'GET /password-reset/<token>' do
    context 'when invalid token' do
      it 'returns to home page' do
        get :choose_password, params: {token: confirmed_user.reset_token + 'aa', email: confirmed_user.email}
        expect(response).to redirect_to root_path
      end
    end
    context 'when token expired' do
      it 'redirects to password reset page' do
        get :choose_password, params: {token: expired_token_user.reset_token, email: expired_token_user.email}
        expect(response).to redirect_to password_reset_path
      end
    end
    context 'when valid params' do
      it 'returns status 200' do
        get :choose_password, params: {token: confirmed_user.reset_token, email: confirmed_user.email}
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'PUT /password-reset' do
    context 'when invalid user' do
      it 'redirects to home page' do
        patch :reset_password, params: {token: confirmed_user.reset_token, user: {password: confirmed_user.password, password_confirmation: confirmed_user.password}, email: confirmed_user.email + 'aa'}
        expect(response).to redirect_to root_path
      end
    end
    context 'when expired token' do
      it 'redirects to password reset page' do
        patch :reset_password, params: {token: expired_token_user.reset_token, user: {password: expired_token_user.password, password_confirmation: expired_token_user.password}, email: expired_token_user.email}
        expect(response).to redirect_to password_reset_path
      end
    end
    context 'when valid token' do
      it 'changes user password' do
        patch :reset_password, params: {token: confirmed_user.reset_token, user: {password: confirmed_user.password + 'aa', password_confirmation: confirmed_user.password + 'aa'}, email: confirmed_user.email}
        confirmed_user.reload
        expect(confirmed_user.authenticate(confirmed_user.password + 'aa')).to be_truthy
      end
      it 'redirects to user page' do
        patch :reset_password, params: {token: confirmed_user.reset_token, user: {password: confirmed_user.password + 'aa', password_confirmation: confirmed_user.password + 'aa'}, email: confirmed_user.email}
        expect(response).to redirect_to confirmed_user
      end
    end
  end
end

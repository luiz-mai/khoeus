require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:subscription) {create :subscription}
  let(:other_user) {create :other_user}
  let(:classroom) {create :classroom}

  describe 'GET #new' do
    context 'when logged out' do
      it 'redirects to login page' do
        get :new, params: {id: subscription.classroom.id}
        expect(response).to redirect_to login_path
      end
    end
    context 'when user already subscribed' do
      it 'redirects to the classroom' do
        log_in subscription.user
        get :new, params: {id: subscription.classroom.id}
        expect(response).to redirect_to subscription.classroom
      end
    end
    context 'when user not subscribed' do
      it 'returns status 200' do
        log_in other_user
        get :new, params: {id: subscription.classroom.id}
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'POST #create' do
    context 'when correct password' do
      it 'subscribes the user' do
        log_in other_user
        expect{
        post :create, params: { id: classroom.id, subscription: { password: classroom.password } }
        }.to change(Subscription, :count).by(1)
      end
      it 'redirects the user to the classroom' do
        log_in other_user
        post :create, params: { id: classroom.id, subscription: { password: classroom.password } }
        expect(response).to redirect_to classroom
      end
    end

    context 'when incorrect password' do
      it 'returns to the subscription form' do
        log_in other_user
        post :create, params: { id: classroom.id, subscription: { password: classroom.password + 'aaa' } }
        expect(response).to render_template :new
      end
    end
  end

end

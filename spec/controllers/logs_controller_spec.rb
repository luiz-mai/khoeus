require 'rails_helper'

RSpec.describe LogsController, type: :controller do
  let(:subscription) {create :subscription}
  let(:teacher_subscription) {create :teacher_subscription}

  describe 'GET /logs' do
    context 'when logged out' do
      it 'redirects to login page' do
        get :admin_index
        expect(response).to redirect_to login_path
      end
    end
    context 'when non-admin user' do
      it 'returns status 403' do
        log_in subscription.user
        get :admin_index
        expect(response).to have_http_status 403
      end
    end
    context 'when admin' do
      it 'returns status 200' do
        subscription.user.admin = true
        log_in subscription.user
        get :admin_index
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'GET /classroom/:id/logs' do
    context 'when logged out' do
      it 'redirects to login page' do
        get :teacher_index, params: {classroom_id: subscription.classroom.id}
        expect(response).to redirect_to login_path
      end
    end
    context 'when unsubscribed user' do
      it 'redirects to classroom page' do
        log_in subscription.user
        get :teacher_index, params: {classroom_id: subscription.classroom.id}
        expect(response).to redirect_to subscription.classroom
      end
    end
    context 'when student user' do
      it 'returns to classroom page' do
        subscription.role = 'student'
        log_in subscription.user
        get :teacher_index, params: {classroom_id: subscription.classroom.id}
        expect(response).to redirect_to subscription.classroom
      end
    end
    context 'when teacher user' do
      it 'returns status 200' do
        log_in teacher_subscription.user
        get :teacher_index, params: {classroom_id: teacher_subscription.classroom.id}
        expect(response).to have_http_status 200
      end
    end
  end

end

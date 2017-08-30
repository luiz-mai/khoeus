require 'rails_helper'

RSpec.describe SectionsController, type: :controller do
  let(:user)  { create :other_user }
  let(:admin_user)  { create :admin_user }
  let(:subscription) { create :subscription }
  let(:teacher_subscription) { create :teacher_subscription }
  let(:section) { create :section }
  let(:classroom) { create :classroom }

  describe 'GET /new' do
    context 'when logged out' do
      it 'redirects to login page' do
        get :new, params: { classroom_id: subscription.classroom.id }
        expect(response).to redirect_to login_path
      end
    end
    context 'when unsubscribed user' do
      it 'redirects to subscribe page' do
        log_in user
        get :new, params: { classroom_id: subscription.classroom.id }
        expect(response).to have_http_status 403
      end
    end
    context 'when student' do
      it 'returns status 403' do
        subscription.role = 'student'
        log_in subscription.user
        get :new, params: { classroom_id: subscription.classroom.id }
        expect(response).to have_http_status 403
      end
    end
    context 'when teacher' do
      it 'returns status 200' do
        log_in teacher_subscription.user
        get :new, params: { classroom_id: teacher_subscription.classroom.id }
        expect(response).to have_http_status 200
      end
    end
    context 'when admin' do
      it 'returns status 200' do
        log_in admin_user
        get :new, params: { classroom_id: teacher_subscription.classroom.id }
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'GET /edit' do
    context 'when logged out' do
      it 'redirects to login page' do
        get :edit, params: { classroom_id: subscription.classroom.id, id: section.id }
        expect(response).to redirect_to login_path
      end
    end
    context 'when unsubscribed user' do
      it 'redirects to subscribe page' do
        log_in user
        get :edit, params: { classroom_id: subscription.classroom.id, id: section.id }
        expect(response).to have_http_status 403
      end
    end
    context 'when student' do
      it 'returns status 403' do
        log_in subscription.user
        get :new, params: { classroom_id: subscription.classroom.id, id: section.id }
        expect(response).to have_http_status 403
      end
    end
    context 'when teacher' do
      it 'returns status 200' do
        log_in teacher_subscription.user
        get :new, params: { classroom_id: teacher_subscription.classroom.id, id: section.id  }
        expect(response).to have_http_status 200
      end
    end
    context 'when admin' do
      it 'returns status 200' do
        log_in admin_user
        get :new, params: { classroom_id: teacher_subscription.classroom.id, id: section.id  }
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Section' do
        log_in admin_user
        expect {
          post :create, params: {classroom_id: classroom.id, section: attributes_for(:section)}
        }.to change(Section, :count).by(1)
      end

      it 'redirects to the classroom' do
        log_in admin_user
        post :create, params: {classroom_id: classroom.id, section: attributes_for(:section, classroom: classroom)}
        expect(response).to redirect_to(classroom)
      end
    end

    context 'with invalid params' do
      it 'returns to new page' do
        log_in admin_user
        post :create, params: {classroom_id: classroom.id, section: attributes_for(:section, title: nil)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      before(:each) {
        log_in admin_user
      }
      it 'updates the requested section' do
        put :update, params: {classroom_id: section.classroom, id: section.id, section: attributes_for(:section, :title => 'New Title') }
        section.reload
        expect(section.title).to eq('New Title')
      end
      it 'redirects to the classroom' do
        put :update, params: {classroom_id: section.classroom, id: section.id, section: attributes_for(:section, :title => 'New Title')}
        expect(response).to redirect_to(section.classroom)
      end
    end
    context 'with invalid params' do
      it 'returns to edit page' do
        log_in admin_user
        put :update, params: {classroom_id: section.classroom, id: section.id, section: attributes_for(:section, :title => nil)}
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) {
      section
      log_in admin_user
    }
    it 'destroys the requested section' do
      expect {
        delete :destroy, params: {classroom_id: section.classroom.id, id: section.id}
      }.to change(Section, :count).by(-1)
    end

    it 'redirects to the sections list' do
      delete :destroy, params: {classroom_id: section.classroom.id, id: section.id}
      expect(response).to redirect_to(section.classroom)
    end
  end

end

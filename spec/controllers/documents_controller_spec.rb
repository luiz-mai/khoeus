require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  let(:user)  { create :other_user }
  let(:admin_user)  { create :admin_user }
  let(:classroom) { create :classroom }
  let(:subscription) { create :subscription, classroom: classroom }
  let(:teacher_subscription) { create :teacher_subscription }
  let(:section) { create :section, classroom: classroom }
  let(:document) { create :document}

  describe 'GET /new' do
    context 'when logged out' do
      it 'redirects to login page' do
        get :new, params: { classroom_id: subscription.classroom.id, section: document.section.id }
        expect(response).to redirect_to login_path
      end
    end
    context 'when unsubscribed user' do
      it 'redirects to subscribe page' do
        log_in user
        get :new, params: { classroom_id: subscription.classroom.id, section: document.section.id  }
        expect(response).to have_http_status 403
      end
    end
    context 'when student' do
      it 'returns status 403' do
        subscription.role = 'student'
        log_in subscription.user
        get :new, params: { classroom_id: subscription.classroom.id, section: document.section.id  }
        expect(response).to have_http_status 403
      end
    end
    context 'when teacher' do
      it 'returns status 200' do
        log_in teacher_subscription.user
        get :new, params: { classroom_id: teacher_subscription.classroom.id, section: document.section.id }
        expect(response).to have_http_status 200
      end
    end
    context 'when admin' do
      it 'returns status 200' do
        log_in admin_user
        get :new, params: { classroom_id: subscription.classroom.id, section: document.section.id  }
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'GET /edit' do
    context 'when logged out' do
      it 'redirects to login page' do
        get :edit, params: { classroom_id: subscription.classroom.id, id: document.id }
        expect(response).to redirect_to login_path
      end
    end
    context 'when unsubscribed user' do
      it 'redirects to subscribe page' do
        log_in user
        get :edit, params: { classroom_id: subscription.classroom.id, id: document.id }
        expect(response).to have_http_status 403
      end
    end
    context 'when student' do
      it 'returns status 403' do
        log_in subscription.user
        get :new, params: { classroom_id: subscription.classroom.id, id: document.id }
        expect(response).to have_http_status 403
      end
    end
    context 'when teacher' do
      it 'returns status 200' do
        log_in teacher_subscription.user
        get :new, params: { classroom_id: teacher_subscription.classroom.id, id: document.id  }
        expect(response).to have_http_status 200
      end
    end
    context 'when admin' do
      it 'returns status 200' do
        log_in admin_user
        get :new, params: { classroom_id: teacher_subscription.classroom.id, id: document.id  }
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'POST #create' do
    before(:each) do
      document.section
    end
    context 'with valid params' do
      it 'creates a new Section' do
        log_in admin_user
        expect {
          post :create, params: {classroom_id: section.classroom.id, document: attributes_for(:document, section_id: section.id)}
        }.to change(Document, :count).by(1)
      end

      it 'redirects to the classroom' do
        log_in admin_user
        post :create, params: {classroom_id: section.classroom.id, document: attributes_for(:document, section_id: section.id)}
        expect(response).to redirect_to(section.classroom)
      end
    end

    context 'with invalid params' do
      it 'returns to new page' do
        log_in admin_user
        post :create, params: {classroom_id: section.classroom.id, document: attributes_for(:document, section_id: section.id, title: nil) }
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
        put :update, params: {classroom_id: section.classroom, id: document.id, document: attributes_for(:document, section_id: section.id, :title => 'New Title') }
        document.reload
        expect(document.title).to eq('New Title')
      end
      it 'redirects to the classroom' do
        put :update, params: {classroom_id: section.classroom, id: document.id, document: attributes_for(:document, section_id: section.id, :title => 'New Title')}
        expect(response).to redirect_to(section.classroom)
      end
    end
    context 'with invalid params' do
      it 'returns to edit page' do
        log_in admin_user
        put :update, params: {classroom_id: section.classroom, id: document.id, document: attributes_for(:document, section_id: section.id, :title => nil)}
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each) {
      document
      log_in admin_user
    }
    it 'destroys the requested section' do
      expect {
        delete :destroy, params: {classroom_id: section.classroom.id, id: document.id}
      }.to change(Document, :count).by(-1)
    end

    it 'redirects to the sections list' do
      delete :destroy, params: {classroom_id: section.classroom.id, id: document.id}
      expect(response).to redirect_to(section.classroom)
    end
  end

end

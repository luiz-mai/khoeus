require 'rails_helper'

RSpec.describe ClassroomsController, type: :controller do
  let(:user) {create :user, confirmed: true}
  let(:other_user) {create :user, email: 'aaa@gmail.com', confirmed: true}
  let(:admin_user) {create :admin_user}
  let(:classroom) {create :classroom}
  let(:subscription) {create :subscription}
  let(:teacher_subscription) {create :teacher_subscription}

  describe 'GET #index' do
    context 'when logged in' do
      it 'returns a success response' do
        log_in user
        get :index
        expect(response).to have_http_status 200
      end
    end
    context 'when logged out' do
      it 'redirects to login' do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET #members' do
    context 'when logged out' do
      it 'redirects to login page' do
        get :members, params: {classroom_id: classroom.id}
        expect(response).to redirect_to login_path
      end
    end
    context 'when not a member' do
      it 'redirects to subscription page' do
        log_in other_user
        get :members, params: {classroom_id: classroom.id}
        expect(response).to redirect_to subscribe_path classroom.id
      end
    end
    context 'when is a member' do
      it 'returns status 200' do
        log_in subscription.user
        get :members, params: {classroom_id: subscription.classroom.id}
        expect(response).to have_http_status 200
      end
    end
  end

  describe 'GET #show' do
    context 'when admin' do
      it 'returns a success response' do
        log_in admin_user
        get :show, params: {id: classroom.id}
        expect(response).to have_http_status 200
      end
    end
    context 'when user is member' do
      it 'returns a success response' do
        log_in subscription.user
        get :show, params: {id: subscription.classroom.id}
        expect(response).to have_http_status 200
      end
    end
    context 'when user is not a member' do
      it 'redirects to subscription page' do
        log_in other_user
        get :show, params: {id: classroom.id}
        expect(response).to redirect_to subscribe_path
      end
    end
    context 'when logged out' do
      it 'redirects to login page' do
        get :show, params: {id: classroom.to_param}
        expect(response).to redirect_to login_path
      end
    end

  end

  describe 'GET #new' do
    context 'when admin' do
      it 'returns a success response' do
        log_in admin_user
        get :new
        expect(response).to have_http_status 200
      end
    end
    context 'when not admin' do
      it 'returns status 403' do
        log_in user
        get :new
        expect(response).to have_http_status 403
      end
    end
    context 'when logged out' do
      it 'redirect to login page' do
        get :new
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET #edit' do
    context 'when admin user' do
      it 'returns a success response' do
        log_in admin_user
        get :edit, params: {id: classroom.id}
        expect(response).to have_http_status 200
      end
    end
    context 'when teacher user' do
      it 'returns a success response' do
        log_in teacher_subscription.user
        get :edit, params: { id: teacher_subscription.classroom.id}
        expect(response).to have_http_status 200
      end
    end
    context 'when student user' do
      before(:each) do
        create :student_subscription, user: user, classroom: classroom
      end
      it 'returns status 403' do
        log_in user
        get :edit, params: {id: classroom.id}
        expect(response).to have_http_status 403
      end
    end
    context 'when logged out' do
      it 'redirects to login_page' do
        get :edit, params: {id: classroom.id}
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'POST #create' do
    context 'when not admin' do
      it 'returns status 403' do
        log_in user
        post :create, params: {classroom: attributes_for(:classroom)}
        expect(response).to have_http_status 403
      end
    end
    context 'when admin with invalid params' do
      it 'redirects to create page' do
        log_in admin_user
        post :create, params: {classroom: attributes_for(:classroom, name: nil)}
        expect(response).to render_template :new
      end
    end
    context 'when admin with valid params' do
      before(:each) {log_in admin_user}
      it 'creates a new Classroom' do
        expect {
          post :create, params: {classroom: attributes_for(:classroom)}
        }.to change(Classroom, :count).by(1)
      end

      it 'redirects to the created classroom' do
        post :create, params: {classroom: attributes_for(:classroom)}
        expect(response).to redirect_to(Classroom.last)
      end
    end

  end

  describe 'PUT #update' do
    before(:each){classroom = Classroom.create attributes_for(:classroom)}

    context 'when not admin' do
      it 'returns status 403' do
        log_in subscription.user
        put :update, params: {id: subscription.classroom.id, classroom: attributes_for(:classroom, name: 'New Name')}
        expect(response).to have_http_status 403
      end
    end
    context 'when admin with invalid params' do
      it 'returns to edit page' do
        log_in admin_user
        put :update, params: {id: classroom.id, classroom: attributes_for(:classroom, name: nil)}
        expect(response).to render_template :edit
      end
    end
    context 'when admin with valid params' do
      before(:each) {log_in admin_user}
      it 'updates the requested classroom' do
        put :update, params: {id: classroom.id, classroom: attributes_for(:classroom, name: 'New Name')}
        classroom.reload
        expect(classroom.name).to eq('New Name')
      end
      it 'redirects to the classroom' do
        put :update, params: {id: classroom.id, classroom: attributes_for(:classroom, name: 'New Name')}
        expect(response).to redirect_to classroom
      end
    end
  end

  describe 'DELETE #destroy' do
    before(:each){classroom = Classroom.create attributes_for(:classroom)}

    context 'when not admin' do
      it 'returns status 403' do
        log_in user
        delete :destroy, params: {id: classroom.id}
        expect(response).to have_http_status 403
      end
    end

    context 'when admin user' do
      before(:each) {
        classroom
        log_in admin_user
      }
      it 'destroys the requested classroom' do
        expect {
          delete :destroy, params: {id: classroom.id}
        }.to change(Classroom, :count).by(-1)
      end

      it 'redirects to the classrooms list' do
        delete :destroy, params: {id: classroom.id}
        expect(response).to redirect_to classrooms_url
      end
    end
  end

end

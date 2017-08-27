class ClassroomsController < ApplicationController
  include UsersHelper

  load_and_authorize_resource

  before_action :set_classroom, only: [:show, :members, :edit, :update, :destroy]
  before_action :admin_only, only: [:new, :create, :destroy]
  before_action :teacher_only, only: [:edit, :update]
  before_action :student_only, only: [:show, :members]

  # GET /classrooms
  def index
    @classrooms = Classroom.all
    generate_log('viewed all', 'Classroom')
  end

  def members
    @members = Subscription.where(classroom_id: @classroom).map(&:user)
    generate_log('viewed members of', 'Classroom', @classroom.id, @classroom.id)
  end

  # GET /classrooms/1
  def show
    generate_log('viewed', 'Classroom', @classroom.id, @classroom.id)
  end

  # GET /classrooms/new
  def new
    @classroom = Classroom.new
  end

  # GET /classrooms/1/edit
  def edit
  end

  # POST /classrooms
  def create
    @classroom = Classroom.new(classroom_params)

    if ManageClassroomService.new(@classroom).create
      generate_log('created', 'Classroom', @classroom.id, @classroom.id)
      redirect_to @classroom, notice: 'Classroom was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /classrooms/1
  def update
    if ManageClassroomService.new(@classroom).edit(classroom_params)
      generate_log('edited', 'Classroom', @classroom.id, @classroom.id)
      redirect_to @classroom, notice: 'Classroom was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /classrooms/1
  def destroy
    generate_log('deleted', 'Classroom', @classroom.id, @classroom.id)
    ManageClassroomService.new(@classroom).delete
    redirect_to classrooms_url, notice: 'Classroom was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classroom
      @classroom = Classroom.find_by(id: params[:id]) ||  Classroom.find_by(id: params[:classroom_id])
    end

    # Only allow a trusted parameter "white list" through.
    def classroom_params
      params.require(:classroom).permit(:name, :password, :has_grades, :ha_attendance, :minimum_grade )
    end

    def admin_only
      current_user.admin?
    end

    def teacher_only
      unless current_user.admin? || current_user.subscriptions.find_by(classroom_id: @classroom.id).role == 'teacher'
        redirect_to subscribe_path(@classroom.id)
      end
    end

    def student_only
      unless current_user.admin? || current_user.subscriptions.where(classroom_id: @classroom.id).exists?
        redirect_to subscribe_path(@classroom.id)
      end
    end
end

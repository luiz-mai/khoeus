class ExternalActivitiesController < ApplicationController
  include ClassroomsHelper

  before_action :set_external_activity, only: [:edit, :update, :destroy, :evaluation, :evaluate]
  before_action :set_classroom
  before_action :set_section, only: [:create]
  before_action :set_student, only: [:evaluate, :evaluation]

  load_and_authorize_resource :external_activity

  # GET /sections/1
  def show
    generate_log('viewed', 'ExternalActivity', @external_activity.id, @classroom.id)
  end

  # GET /sections/new
  def new
    @external_activity = ExternalActivity.new
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections
  def create
    if (last_item = ManageBoardItemService.new.retrieve_last_from_section(@section))
      position = last_item.position + 1
    else
      position = 1
    end
    if ManageExternalActivityService.new.create(external_activity_params.merge!(section: @section, position: position))
      redirect_to @classroom, notice: 'ExternalActivity was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sections/1
  def update
    if ManageAssignmentService.new(@external_activity).update(external_activity_params)
      redirect_to @classroom, notice: 'ExternalActivity was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sections/1
  def destroy
    ManageExternalActivityService.new(@external_activity).delete
    redirect_to @classroom, notice: 'ExternalActivity was successfully destroyed.'
  end

  def evaluation
  end

  def evaluate
    if external_activity_params[:grade] && !external_activity_params[:grade].blank?
      activity_params = {:user_id => @student.id, :external_activity_id => @external_activity.id, :grade => external_activity_params[:grade]}
      activity = ManageActivityService.new.create(activity_params)
      if external_activity_params[:feedback] && !external_activity_params[:feedback].blank?
        feedback_params = {:feedback => external_activity_params[:feedback], :activity_id => activity.id}
        ManageTextFeedbackService.new.create(feedback_params)
      end
    end
    redirect_to @classroom, notice: 'ExternalActivity was successfully reviewed.'
  end


  private
  def set_external_activity
    @external_activity = params[:external_activity_id] ? ManageExternalActivityService.new.retrieve(params[:external_activity_id]) : ManageExternalActivityService.new.retrieve(params[:id])
  end

  def set_classroom
    @classroom = current_classroom
  end

  def set_section
    @section = ManageSectionService.new.retrieve(params[:external_activity][:section_id])
  end

  def set_student
    @student = ManageUserService.new.retrieve(params[:user_id])
  end

  def external_activity_params
    params.require(:external_activity).permit(:title, :description, :section_id, :grade, :feedback)
  end

end

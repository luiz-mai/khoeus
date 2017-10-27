class AssignmentsController < ApplicationController
  include ClassroomsHelper
  include AssignmentsHelper

  before_action :set_assignment, only: [:edit, :update, :destroy, :submit, :evaluation, :evaluate]
  before_action :set_classroom
  before_action :set_section, only: [:create]
  before_action :set_student, only: [:evaluate, :evaluation]

  load_and_authorize_resource :assignment

  # GET /sections/1
  def show
    generate_log('viewed', 'Assignment', @assignment.id, @classroom.id)
  end

  # GET /sections/new
  def new
    @assignment = Assignment.new
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
    if ManageAssignmentService.new.create(assignment_params.merge!(section: @section, position: position))
      redirect_to @classroom, notice: 'Assignment was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sections/1
  def update
    if ManageAssignmentService.new(@assignment).update(assignment_params)
      redirect_to @classroom, notice: 'Assignment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sections/1
  def destroy
    ManageAssignmentService.new(@assignment).delete
    redirect_to @classroom, notice: 'Assignment was successfully destroyed.'
  end

  def submit
    if @assignment.assignment_type == "code"
      params = {:user_id => current_user.id, :assignment_id => @assignment.id, :language => assignment_params[:code_language]}
      code = ManageCodeSubmissionService.new.create(params)
      code_lines = assignment_params['code'].split(/\r\n/)
      code_lines.each_with_index do |line, index|
        line_params = {:code_submission_id => code.id, :line_number => index + 1, :content => line}
        ManageCodeLineService.new.create(line_params)
      end
    elsif @assignment.assignment_type == "file"
      params = {:user_id => current_user.id, :assignment_id => @assignment.id, :assignment_file => assignment_params[:assignment_file]}
      ManageFileSubmissionService.new.create(params)
    else
      params = {:user_id => current_user.id, :assignment_id => @assignment.id, :content => assignment_params[:content]}
      ManageTextSubmissionService.new.create(params)
    end

    redirect_to @classroom, notice: 'Assignment was successfully submitted.'
  end


  private
  def set_assignment
    @assignment = params[:assignment_id] ? ManageAssignmentService.new.retrieve(params[:assignment_id]) : ManageAssignmentService.new.retrieve(params[:id])
  end

  def set_classroom
    @classroom = current_classroom
  end

  def set_section
    @section = ManageSectionService.new.retrieve(params[:assignment][:section_id])
  end

  def set_student
    @student = ManageUserService.new.retrieve(params[:user_id])
  end

  def assignment_params
    params.require(:assignment).permit(:title, :description, :assignment_type, :start_time, :end_time, :file_limit, :section_id, :assignment_file, :content, :code, :code_language, :grade, :feedback)
  end
end

require 'hacker_earth'

class AssignmentsController < ApplicationController
  include ClassroomsHelper
  include AssignmentsHelper

  before_action :set_assignment, only: [:edit, :update, :destroy, :submit, :evaluation, :evaluate]
  before_action :set_classroom, except: [:compile]
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
    elsif @assignment.assignment_type == 'file'
      params = {:user_id => current_user.id, :assignment_id => @assignment.id, :assignment_file => assignment_params[:assignment_file]}
      ManageFileSubmissionService.new.create(params)
    else
      params = {:user_id => current_user.id, :assignment_id => @assignment.id, :content => assignment_params[:content]}
      ManageTextSubmissionService.new.create(params)
    end

    redirect_to @classroom, notice: 'Assignment was successfully submitted.'
  end

  def compile
    if request.xhr?
      secret = ENV['HACKER_EARTH_KEY']
      lang = 'C'
      hackerearth = HackerEarth.new(secret,params[:code],lang)
      result = JSON.parse(hackerearth.run)
      render json: { result: result }
    else
      redirect_to @content
    end
  end

  def evaluation
  end

  def evaluate
    if submission_params[:feedback] && !submission_params[:feedback].blank?
        feedback_params = {:feedback => submission_params[:feedback], :submission_id => student_submission(@student).id}
        ManageTextFeedbackService.new.create(feedback_params)
    end
    if submission_params[:grade] && !submission_params[:grade].blank?
      submission = student_submission(@student)
      ManageSubmissionService.new(submission).update_grade(submission_params[:grade])
    end
    if submission_params[:code_line]
      submission_params[:code_line].each do |key, value|
        puts value.inspect
        unless value['feedback'].blank?
          feedback_params = {:feedback => value['feedback'], :code_line_id => key}
          ManageCodeLineFeedbackService.new.create(feedback_params)
        end
      end
    end
    redirect_to @classroom, notice: 'Assignment was successfully reviewed.'
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
    params.require(:assignment).permit(:title, :description, :assignment_type, :start_time, :end_time, :file_limit, :section_id, :assignment_file, :content, :code, :code_language, :grade, :feedback, :code_line => [:feedback])
  end

  def submission_params
    if @assignment.assignment_type == 'text'
      params.require(:text_submission).permit(:feedback, :grade)
    elsif @assignment.assignment_type == 'file'
      params.require(:file_submission).permit(:feedback, :grade)
    else
      params.require(:code_submission).permit(:feedback, :grade, :code_line => [:feedback])
    end
  end

end

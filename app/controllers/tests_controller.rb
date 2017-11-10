class TestsController < ApplicationController
  include ClassroomsHelper
  include TestsHelper
  include UsersHelper

  before_action :set_test, only: [:edit, :update, :destroy, :solve, :evaluation, :evaluate]
  before_action :set_classroom
  before_action :set_section, only: [:create]
  before_action :set_student, only: [:evaluate, :evaluation]

  load_and_authorize_resource :test

  # GET /sections/1
  def show
    generate_log('viewed', 'Test', @test.id, @classroom.id)
  end

  # GET /sections/new
  def new
    @test = Test.new
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
    if ManageTestService.new.create(test_params.merge!(section: @section, position: position))
      redirect_to @classroom, notice: 'Test was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sections/1
  def update
    if ManageTestService.new(@test).update(test_params)
      redirect_to @classroom, notice: 'Test was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sections/1
  def destroy
    ManageTestService.new(@test).delete
    redirect_to @classroom, notice: 'Test was successfully destroyed.'
  end

  def solve
    if params[:test][:test_alternative]
      params[:test][:test_alternative].each do |key, value|
        response_params = {:user_id => current_user.id, :test_alternative_id => value['chosen_alternative']}
        ManageTestAlternativeResponseService.new.create(response_params)
      end
    end
    if params[:test][:test_question]
      params[:test][:test_question].each do |key, value|
        response_params = {:user_id => current_user.id, :test_question_id => key, :response => value['answer']}
        ManageTestTextResponseService.new.create(response_params)
      end
    end
    redirect_to @classroom, notice: 'Test was successfully answered.'
  end

  def evaluation
  end

  def evaluate
    if params[:test][:test_question]
      params[:test][:test_question].each do |key, value|
        unless value['feedback'].blank?
          question = ManageTestQuestionService.new.retrieve(key)
          if question.question_type == 'objective'
            chosen_alternative = user_test_chosen_alternative(@student, question.id)
            feedback_params = {:feedback => value['feedback'], :test_alternative_response_id => chosen_alternative.id}
          else
            feedback_params = {:feedback => value['feedback'], :test_text_response_id => user_test_response(@student, question.id).id}
          end
          ManageTextFeedbackService.new.create(feedback_params)
        end
        if value['grade'] && !value['grade'].blank?
          response = ManageTestTextResponseService.new.retrieve_by_user_question(@student.id, key)
          ManageTestTextResponseService.new(response).update_grade(value['grade'])
        end
      end
    end
    redirect_to @classroom, notice: 'Test was successfully answered.'
  end

  private
  def set_test
    @test = params[:test_id] ? ManageTestService.new.retrieve(params[:test_id]) : ManageTestService.new.retrieve(params[:id])
  end

  def set_classroom
    @classroom = current_classroom
  end

  def set_section
    @section = ManageSectionService.new.retrieve(params[:test][:section_id])
  end

  def set_student
    @student = ManageUserService.new.retrieve(params[:user_id])
  end

  def test_params
    params.require(:test).permit(:title, :description, :grade_category_id, :start_time, :end_time, :section_id, :chosen_alternative, :answer, :grade, :feedback, :test_questions_attributes => [:id, :question, :question_type, :value, :_destroy, :test_alternatives_attributes => [:content, :correct, :_destroy]])
  end
end

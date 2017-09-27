class SurveysController < ApplicationController
  include ClassroomsHelper
  before_action :set_survey, only: [:edit, :update, :destroy]
  before_action :set_classroom
  before_action :set_section, only: [:create]

  load_and_authorize_resource :survey

  # GET /sections/new
  def new
    @survey = Survey.new
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
    if ManageSurveyService.new.create(survey_params.merge!(section: @section, position: position))
      redirect_to @classroom, notice: 'Survey was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sections/1
  def update
    if ManageSurveyService.new(@survey).update(survey_params)
      redirect_to @classroom, notice: 'Survey was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sections/1
  def destroy
    ManageSurveyService.new(@survey).delete
    redirect_to @classroom, notice: 'Survey was successfully destroyed.'
  end

  private
  def set_survey
    @survey = ManageSurveyService.new.retrieve(params[:id])
  end

  def set_classroom
    @classroom = current_classroom
  end

  def set_section
    @section = ManageSectionService.new.retrieve(params[:survey][:section_id])
  end

  def link_params
    params.require(:survey).permit(:title, :description, :start_time, :end_time, :section_id)
  end
end

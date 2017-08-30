class SectionsController < ApplicationController
  include ClassroomsHelper
  before_action :set_section, only: [:edit, :update, :destroy]
  before_action :set_classroom

  load_and_authorize_resource :classroom
  load_and_authorize_resource :section, :through => :classroom

  # GET /sections/new
  def new
    @section = Section.new
  end

  # GET /sections/1/edit
  def edit
  end

  # POST /sections
  def create
    @section = Section.new(section_params)

    if ManageSectionService.new(@section).create(current_classroom)
      redirect_to @classroom, notice: 'Section was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sections/1
  def update
    if ManageSectionService.new(@section).edit(section_params)
      redirect_to @classroom, notice: 'Section was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sections/1
  def destroy
    ManageSectionService.new(@section).delete
    redirect_to @classroom, notice: 'Section was successfully destroyed.'
  end

  private
    def set_section
      @section = Section.find(params[:id])
    end

    def set_classroom
      @classroom = current_classroom
    end

    def section_params
      params.require(:section).permit(:title, :description, :position, :classroom)
    end
end

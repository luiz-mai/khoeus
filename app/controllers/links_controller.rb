class LinksController < ApplicationController
  include ClassroomsHelper
  before_action :set_link, only: [:edit, :update, :destroy]
  before_action :set_classroom
  before_action :set_section, only: [:create]

  load_and_authorize_resource :link

  # GET /sections/new
  def new
    @link = Link.new
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
    if ManageLinkService.new.create(link_params.merge!(section: @section, position: position))
      redirect_to @classroom, notice: 'Link was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /sections/1
  def update
    if ManageLinkService.new(@link).update(link_params)
      redirect_to @classroom, notice: 'Link was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sections/1
  def destroy
    ManageLinkService.new(@link).delete
    redirect_to @classroom, notice: 'Link was successfully destroyed.'
  end

  private
  def set_link
    @link = ManageLinkService.new.retrieve(params[:id])
  end

  def set_classroom
    @classroom = current_classroom
  end

  def set_section
    @section = ManageSectionService.new.retrieve(params[:link][:section_id])
  end

  def link_params
    params.require(:link).permit(:title, :description, :uri, :section_id)
  end
end

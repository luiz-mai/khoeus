class DocumentsController < ApplicationController
  include ClassroomsHelper
  before_action :set_document, only: [:edit, :update, :destroy]
  before_action :set_classroom
  before_action :set_section, only: [:create]

  load_and_authorize_resource :document

  # GET /sections/new
  def new
    @document = Document.new
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
    if ManageDocumentService.new.create(document_params.merge!(section: @section, position: position))
      redirect_to @classroom, notice: 'File was successfully created.'
    else
      flash.now[:danger] = 'An error has occurred'
      render :new
    end
  end

  # PATCH/PUT /sections/1
  def update
    if ManageDocumentService.new(@document).update(document_params)
      redirect_to @classroom, notice: 'File was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /sections/1
  def destroy
    ManageDocumentService.new(@document).delete
    redirect_to @classroom, notice: 'File was successfully destroyed.'
  end

  private
  def set_document
    @document = ManageDocumentService.new.retrieve(params[:id])
  end

  def set_classroom
    @classroom = current_classroom
  end

  def set_section
    @section = ManageSectionService.new.retrieve(params[:document][:section_id])
  end

  def document_params
    params.require(:document).permit(:title, :description, :document_file, :section_id)
  end
end

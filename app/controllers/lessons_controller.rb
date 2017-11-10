class LessonsController < ApplicationController
  include ClassroomsHelper

  before_action :set_lesson, only: [:edit, :update, :destroy, :new_attendance, :create_attendance]
  before_action :set_classroom

  load_and_authorize_resource :lesson

  def index
    @lessons = ManageLessonService.new.list_from_classroom(@classroom)
  end

  def new
    @lesson = Lesson.new
  end

  def create
    if ManageLessonService.new.create(lesson_params.merge!(classroom: current_classroom))
      redirect_to classroom_lessons_path(@classroom), notice: 'Lesson was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if ManageLessonService.new(@lesson).update(lesson_params)
      redirect_to classroom_lessons_path, notice: 'Lesson was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    ManageLessonService.new(@lesson).delete
    redirect_to classroom_lessons_path, notice: 'Lesson was successfully destroyed.'
  end

  def attendances
  end

  def new_attendance
    @students = current_classroom.subscriptions.collect(&:user)
  end

  def create_attendance
    if lesson_params[:user] && !lesson_params[:user].blank?
      lesson_params[:user].each do |key, value|
        unless value['presence'].blank?
          presence_params = {user_id: key, lesson_id: @lesson.id, present: value['presence']}
          ManagePresenceService.new.create(presence_params)
        end
      end
    end
    redirect_to classroom_lessons_path(@classroom), notice: 'Attendances were created successfully.'
  end

  private
  def set_lesson
    @lesson = params[:lesson_id] ? ManageLessonService.new.retrieve(params[:lesson_id]) : ManageLessonService.new.retrieve(params[:id])
  end

  def set_classroom
    @classroom = current_classroom
  end

  def lesson_params
    params.require(:lesson).permit(:title, :description, :date, :classroom_id, :user => [:presence])
  end
end

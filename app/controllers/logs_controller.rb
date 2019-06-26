class LogsController < ApplicationController

  load_and_authorize_resource :log

  before_action :set_classroom, only: [:teacher_index]
  before_action :admin_only, only: [:admin_index]
  before_action :teacher_only, only: [:teacher_index]

  def admin_index
    @logs = Log.all
  end

  def teacher_index
    @logs = Log.where(classroom_id: @classroom.id)
  end

  private

    def set_classroom
      @classroom = Classroom.find_by(id: params[:classroom_id])
    end

    def admin_only
      current_user.admin?
    end

    def teacher_only
      unless current_user.admin? || current_user.subscriptions.find_by(classroom_id: @classroom.id).role == 'teacher'
        redirect_to @classroom
      end
    end


end

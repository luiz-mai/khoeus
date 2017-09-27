class ManageClassroomService < CrudService

  def initialize(classroom = nil)
    if classroom
      @classroom = classroom
      super('Classroom', classroom)
    else
      super('Classroom')
    end
  end

  def students_count
    @classroom.subscriptions.size
  end
end
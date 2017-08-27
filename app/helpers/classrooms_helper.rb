module ClassroomsHelper

  def students_count(classroom)
    ManageClassroomService.new(classroom).students_count
  end

  def current_classroom
    id = request.env['PATH_INFO'].split('/classrooms/')[1].split('/')[0]
    Classroom.find_by(id: id)
  end
end

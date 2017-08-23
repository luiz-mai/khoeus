module ClassroomsHelper

  def students_count(classroom)
    ManageClassroomService.new(classroom).students_count
  end

end

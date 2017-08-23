class ManageClassroomService
  include Tokens

  def initialize(classroom)
    @classroom = classroom
  end

  def create
    @classroom.save
  end

  def edit(classroom_params)
    @classroom.update_attributes(classroom_params)
  end

  def delete
    @classroom.destroy
  end

  def students_count
    @classroom.subscriptions.size
  end
end
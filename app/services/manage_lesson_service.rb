class ManageLessonService < CrudService

  def initialize(lesson = nil)
    if lesson
      @lesson = lesson
      super('Lesson', lesson)
    else
      super('Lesson')
    end
  end

  def list_from_classroom(classroom)
    Lesson.all.where(:classroom_id => classroom.id)
  end
end
module LessonsHelper
  include ClassroomsHelper

  def classroom_lessons
    current_classroom
        .lessons
        .to_a
  end

  def lessons_titles
    classroom_lessons.map(&:title)
  end

  def student_presence(student, lesson)
    unless student.presences.empty?
      student.presences
          .where(lesson_id: lesson.id)
          .first
    end

  end

  def lessons_attendances
    attendances = []
    for student in current_classroom.subscriptions.collect(&:user).sort_by(&:name)
      student_attendances = []
      percentage = 0
      student_attendances.push(student.name)
      for lesson in classroom_lessons
        if (presence = student_presence(student, lesson))
          if presence.present
            percentage += 1
            student_attendances.push(fa_icon 'check')
          else
            student_attendances.push(fa_icon 'close')
          end
        else
          student_attendances.push('-')
        end
      end
      student_attendances.push(number_to_percentage(percentage/classroom_lessons.size.to_f * 100, precision: 2))
      attendances.push(student_attendances)
    end
    attendances
  end
end

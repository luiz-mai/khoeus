module GradesHelper
  include ClassroomsHelper
  include TestsHelper
  include AssignmentsHelper
  include ExternalActivitiesHelper

  def grade_activities
    current_classroom
        .sections
        .map(&:board_items)
        .select{|item| !item.empty?}
        .flatten
        .select{|item| item.type == 'Test' || item.type == 'Assignment' || item.type == 'ExternalActivity'}
  end

  def activities_titles
    grade_activities.map(&:title)
  end

  def activities_grades
    grades = []
    total_weight = grade_activities.collect(&:grade_category).map(&:weight).inject(0, :+)
    for student in current_classroom.subscriptions.collect(&:user)
      student_grades = []
      final_grade = 0
      student_grades.push(student.name)
      for activity in grade_activities
        grade = 0
        if activity.type == 'Test'
          grade = students_test_grade(student, activity)
        elsif activity.type == 'Assignment'
          grade = assignment_grade(student, activity)
        elsif activity.type == 'ExternalActivity'
          grade = activity_grade(student, activity)
        end
        student_grades.push(grade)
        final_grade += grade * activity.grade_category.weight
      end
      student_grades.push(final_grade/total_weight)
      grades.push(student_grades)
    end
    grades
  end

end

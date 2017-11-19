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

  def classroom_activities
    grades = []
    final_grade = 0
    total_weight = grade_activities.collect(&:grade_category).map(&:weight).inject(0, :+)
    for activity in grade_activities
      grade = 0
      if activity.type == 'Test'
        grade = students_test_grade(current_user, activity)
      elsif activity.type == 'Assignment'
        grade = assignment_grade(current_user, activity)
      elsif activity.type == 'ExternalActivity'
        grade = activity_grade(current_user, activity)
      end
      grades.push({:title => activity.title, :type => activity.type, :grade => grade})
      final_grade += grade * activity.grade_category.weight
    end
    grades.push({:title => 'Final Average', :grade => (final_grade/total_weight).round(2)})
  end

end

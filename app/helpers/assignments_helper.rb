module AssignmentsHelper
  def submitted_assignment?(assignment_id, student = current_user)
    unless student.test_text_responses.empty?
      return true unless student.submissions
                             .collect(&:test)
                             .uniq
                             .select { |assignment| assignment.id == assignment_id }
                             .empty?
    end
  end

  def evaluated_assignment?(assignment, student)
    if !student.submissions.empty?
      submission = student.submissions.where(:assignment_id => assignment.id).first
      if !submission.grade.nil?
        'Yes'
      else
        'No'
      end
    else
      '-'     #User didnt answer
    end
  end

  def students_assignment_grade(student)
    submission = student.submissions.where(assignment_id: @assignment.id)
    if submission.empty?
      0
    else
      submission.grade
    end
  end
end
module AssignmentsHelper
  def submitted_assignment?(assignment_id, student = current_user)
    unless student.submissions.empty?
      return true unless student.submissions
                             .select { |submission| submission.assignment_id == assignment_id }
                             .empty?
    end
  end

  def evaluated_assignment?(assignment, student)
    if !student.submissions.empty? && !student.submissions.where(:assignment_id => assignment.id).empty?
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

  def assignment_grade(student, assignment)
    submission = student.submissions.where(assignment_id: assignment.id).first
    submission && !submission.grade.blank? ? submission.grade : 0
  end

  def submission_feedback(student)
    submission = student.submissions.where(assignment_id: @assignment.id).first
    feedback = ManageTextFeedbackService.new.list.select {|feedback| feedback.submission_id == submission.id }
    unless feedback.empty?
      feedback.first.feedback
    end
  end

  def line_feedback(line)
    feedback = ManageCodeLineFeedbackService.new.list.select {|feedback| feedback.code_line_id == line.id }
    unless feedback.empty?
      feedback.first.feedback
      end
  end

  def student_submission(student)
    student.submissions.where(assignment_id: @assignment.id).first
  end

  def student_code(student)
    student_submission(student).code_lines.map(&:content).join('<br>')
  end
end

module ExternalActivitiesHelper

  def evaluated_activity?(external_activity, student)
    if !student.activities.empty? && !student.activities.where(:external_activity_id => external_activity.id).empty?
      activity = student.activities.where(:external_activity_id => external_activity.id).first
      if !activity.grade.nil?
        'Yes'
      else
        'No'
      end
    else
      '-'     #User didnt answer
    end
  end

  def activity_grade(student)
    activity = student.activities.where(external_activity_id: @external_activity.id).first
    activity && !activity.grade.blank? ? activity.grade : 0
  end

  def activity_feedback(student)
    activity = student.activities.where(external_activity_id: @external_activity.id).first
    feedback = ManageTextFeedbackService.new.list.select {|feedback| feedback.activity_id == activity.id }
    unless feedback.empty?
      feedback.first.feedback
    end
  end

  def student_activity(student)
    student.activities.where(external_activity_id: @external_activity.id).first
  end

end

class ManageSubmissionService < CrudService

  def initialize(submission = nil)
    if submission
      @submission = submission
      super('Submission', submission)
    else
      super('Submission')
    end
  end

  def update_grade(grade)
    @submission.update_attribute(:grade, grade)
  end

end
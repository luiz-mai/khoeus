class ManageCodeSubmissionService < CrudService

  def initialize(code_submission = nil)
    if code_submission
      @code_submission = code_submission
      super('CodeSubmission', code_submission)
    else
      super('CodeSubmission')
    end
  end

end
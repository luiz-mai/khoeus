class ManageTextSubmissionService < CrudService

  def initialize(text_submission = nil)
    if text_submission
      @text_submission = text_submission
      super('TextSubmission', text_submission)
    else
      super('TextSubmission')
    end
  end

end
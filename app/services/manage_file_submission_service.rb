class ManageFileSubmissionService < CrudService

  def initialize(file_submission = nil)
    if file_submission
      @file_submission = file_submission
      super('FileSubmission', file_submission)
    else
      super('FileSubmission')
    end
  end

end
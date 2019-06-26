class ManageTextFeedbackService < CrudService

  def initialize(text_feedback = nil)
    if text_feedback
      @text_feedback = text_feedback
      super('TextFeedback', text_feedback)
    else
      super('TextFeedback')
    end
  end

end
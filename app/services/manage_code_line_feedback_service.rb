class ManageCodeLineFeedbackService < CrudService

  def initialize(code_line_feedback = nil)
    if code_line_feedback
      @code_line_feedback = code_line_feedback
      super('CodeLineFeedback', code_line_feedback)
    else
      super('CodeLineFeedback')
    end
  end

end
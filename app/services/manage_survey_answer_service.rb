class ManageSurveyAnswerService < CrudService

  def initialize(survey_answer = nil)
    if survey_answer
      @survey_answer = survey_answer
      super('SurveyAnswer', survey_answer)
    else
      super('SurveyAnswer')
    end
  end

end
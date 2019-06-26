class ManageSurveyResponseService < CrudService

  def initialize(survey_response = nil)
    if survey_response
      @survey_question = survey_response
      super('SurveyResponse', survey_response)
    else
      super('SurveyResponse')
    end
  end

end
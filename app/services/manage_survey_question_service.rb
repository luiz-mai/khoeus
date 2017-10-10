class ManageSurveyQuestionService < CrudService

  def initialize(survey_question = nil)
    if survey_question
      @survey_question = survey_question
      super('SurveyQuestion', survey_question)
    else
      super('SurveyQuestion')
    end
  end

end
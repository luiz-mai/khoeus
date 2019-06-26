class ManageSurveyQuestionService < CrudService

  def initialize(survey_question = nil)
    if survey_question
      @survey_question = survey_question
      super('SurveyQuestion', survey_question)
    else
      super('SurveyQuestion')
    end
  end

  def retrieve_responses
    retrieve(@survey_question.id).survey_answers.collect(&:survey_responses).reject(&:empty?).flatten
  end

end
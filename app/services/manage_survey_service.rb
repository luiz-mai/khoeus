class ManageSurveyService < CrudService

  def initialize(survey = nil)
    if survey
      @survey = survey
      super('Survey', survey)
    else
      super('Survey')
    end
  end

end
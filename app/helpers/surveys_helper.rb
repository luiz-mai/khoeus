module SurveysHelper
  include ClassroomsHelper
  include UsersHelper

  def answered?(survey_id)
    !current_user.survey_responses
        .collect(&:survey_answer)
        .collect(&:survey_question)
        .collect(&:survey)
        .uniq
        .select { |survey| survey.id == survey_id }
        .empty?
  end

  def answer_percentage(question, answer)
    number_to_percentage((ManageSurveyAnswerService
                             .new(answer)
                             .retrieve_responses.count.to_f/
                             ManageSurveyQuestionService
                                 .new(question)
                                 .retrieve_responses.count) * 100,
                         precision: 0)
  end
end

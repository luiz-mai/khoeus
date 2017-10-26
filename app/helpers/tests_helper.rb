module TestsHelper
  include ClassroomsHelper
  include UsersHelper

  def answered_test?(test_id, student = current_user)
    unless student.test_text_responses.empty?
      return true unless student.test_text_responses
             .collect(&:test_question)
             .collect(&:test)
             .uniq
             .select { |test| test.id == test_id }
             .empty?
    end
    unless student.test_alternative_responses.empty?
      return true unless student.test_alternative_responses
                      .collect(&:test_alternative)
                      .collect(&:test_question)
                      .collect(&:test)
                      .uniq
                      .select { |test| test.id == test_id }
                      .empty?
    end
  end

  def evaluated_test?(test, student)
    if !test.test_questions.where(:question_type => 'open-ended').blank?
      if !student.test_text_responses.empty?
        question = test.test_questions.where(:question_type => 'open-ended').first
        response = student.test_text_responses.where(:test_question_id => question.id).first
        if !response.grade.nil?
          'Yes'
        else
          'No'
        end
      else
        '-'     #User didnt answer
      end
    else
      'Yes'  #Only objective questions
    end
  end

  def user_test_response(student, question_id)
    student.test_text_responses.select { |response| response.test_question_id == question_id }.first
  end

  def user_test_chosen_alternative(student, question_id)
    student.test_alternative_responses.includes(:test_alternative).where(:'test_alternatives.test_question_id' => question_id).first
  end

  def students_test_grade(student)
    grade = 0
    for question in @test.test_questions
      weight = question.value
      if question.question_type == 'objective'
        if (chosen_alternative = user_test_chosen_alternative(student, question.id)) && chosen_alternative.test_alternative.correct
          grade += weight
        end
      else
        if user_test_response(student, question.id) && !user_test_response(student, question.id).grade.nil?
          grade += user_test_response(student, question.id).grade
        end
      end
    end
    grade
  end

  def alternative_class(student, question, alternative)
    if alternative == question.test_alternatives.where(:correct => true).first
      if student.test_alternative_responses.find_by(test_alternative_id: alternative.id)
        'response correct'
      else
        'correct'
      end
    else
      if student.test_alternative_responses.find_by(test_alternative_id: alternative.id)
        'response wrong'
      end
    end
  end

end

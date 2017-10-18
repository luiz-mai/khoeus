class ManageTestTextResponseService < CrudService
  include TestsHelper

  def initialize(test_text_response = nil)
    if test_text_response
      @test_text_response = test_text_response
      super('TestTextResponse', test_text_response)
    else
      super('TestTextResponse')
    end
  end

  def retrieve_by_user_question(user_id, question_id)
    TestTextResponse.where(:user_id => user_id, :test_question_id => question_id).first
  end

  def update_grade(grade)
    @test_text_response.update_attribute(:grade, grade)
  end


end
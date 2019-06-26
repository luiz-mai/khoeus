class ManageTestQuestionService < CrudService

  def initialize(test_question = nil)
    if test_question
      @test_question = test_question
      super('TestQuestion', test_question)
    else
      super('TestQuestion')
    end
  end



end
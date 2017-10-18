class ManageTestAlternativeResponseService < CrudService

  def initialize(test_alternative_response = nil)
    if test_alternative_response
      @test_alternative_response = test_alternative_response
      super('TestAlternativeResponse', test_alternative_response)
    else
      super('TestAlternativeResponse')
    end
  end



end
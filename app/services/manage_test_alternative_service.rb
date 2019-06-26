class ManageTestAlternativeService < CrudService

  def initialize(test_alternative = nil)
    if test_alternative
      @test_alternative = test_alternative
      super('TestAlternative', test_alternative)
    else
      super('TestAlternative')
    end
  end



end
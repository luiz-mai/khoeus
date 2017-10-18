class ManageTestService < CrudService

  def initialize(test = nil)
    if test
      @test = test
      super('Test', test)
    else
      super('Test')
    end
  end

end
class ManageAssignmentService < CrudService

  def initialize(assignment = nil)
    if assignment
      @assignment = assignment
      super('Assignment', assignment)
    else
      super('Assignment')
    end
  end

end
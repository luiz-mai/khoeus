class ManageCodeLineService < CrudService

  def initialize(code_line = nil)
    if code_line
      @code_line = code_line
      super('CodeLine', code_line)
    else
      super('CodeLine')
    end
  end

end
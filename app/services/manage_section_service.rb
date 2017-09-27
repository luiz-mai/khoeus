class ManageSectionService < CrudService

  def initialize(section = nil)
    if section
      @section = section
      super('Section', section)
    else
      super('Section')
    end
  end

  def retrieve_from_classroom(classroom)
    Section.where(classroom: classroom).order(:position)
  end

  def retrieve_last_from_classroom(classroom)
    Section.where(classroom: classroom).order(:position).last
  end


end
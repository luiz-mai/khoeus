class ManageSectionService
  include ClassroomsHelper

  def initialize(section)
    @section = section
  end

  def create(classroom)
    @section.classroom = classroom
    @section.save
  end

  def edit(section_params)
    @section.update_attributes(section_params)
  end

  def delete
    @section.destroy
  end

end
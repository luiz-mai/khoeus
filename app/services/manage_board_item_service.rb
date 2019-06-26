class ManageBoardItemService

  def retrieve_from_classroom(classroom)
    sections = Section.where(classroom: classroom).pluck("id")
    BoardItem.where(section: sections)
  end

  def retrieve_last_from_section(section)
    BoardItem.where(section: section).order(:position).last
  end
end
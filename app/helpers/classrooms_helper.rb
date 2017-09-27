module ClassroomsHelper

  def students_count(classroom)
    ManageClassroomService.new(classroom).students_count
  end

  def current_classroom
    id = request.env['PATH_INFO'].split('/classrooms/')[1].split('/')[0]
    ManageClassroomService.new.retrieve(id)
  end

  def items_by_section(section)
    @items.where(section: section)
  end

  def item_path(item)
    case item.type
      when 'Link'
        classroom_link_path(@classroom, item.id)
      when 'Document'
        classroom_document_path(@classroom, item.id)
    end
  end
end

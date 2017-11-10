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
      when 'Survey'
        classroom_survey_path(@classroom, item.id)
      when 'Test'
        classroom_test_path(@classroom, item.id)
      when 'Assignment'
        classroom_assignment_path(@classroom, item.id)
      when 'ExternalActivity'
        classroom_external_activity_path(@classroom, item.id)
    end
  end

  def item_icon(item)
    case item.type
      when 'Link'
        fa_icon 'link'
      when 'Document'
        fa_icon 'file'
      when 'Survey'
        fa_icon 'comment'
      when 'Test'
        fa_icon 'pencil'
      when 'Assignment'
        fa_icon 'code'
      when 'ExternalActivity'
        fa_icon 'book'
    end
  end

  def grade_categories
    @classroom.grade_categories
  end
end

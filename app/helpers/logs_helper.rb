module LogsHelper

  def subject_object(log)
    log.subject.to_s.classify.constantize.find_by(id: log.subject_id)
  end

  def subject_name(log)
    if log.subject && log.subject_id
      subject = subject_object log
      if subject.has_attribute?(:name)
        subject.name
      elsif subject.has_attribute?(:title)
        subject.title
      end
    end
  end
end

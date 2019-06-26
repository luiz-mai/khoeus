class FileSubmission < Submission

  validates_attachment_presence :assignment_file
  validates_attachment_content_type :assignment_file, :content_type => %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/zip application/x-zip)

  before_post_process :skip_for_zip

  def skip_for_zip
    ! %w(application/zip application/x-zip).include?(assignment_file_content_type)
  end

end

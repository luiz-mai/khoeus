class Document < BoardItem

  validates_attachment_presence :document_file
  validates_attachment_content_type :document_file, :content_type => %w(image/jpeg image/jpg image/png application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document)

end

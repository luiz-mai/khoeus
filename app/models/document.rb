class Document < BoardItem

  validates_attachment_presence :document_file
  validates_attachment_content_type :document_file, :content_type => /\Aimage\/.*\Z/

end

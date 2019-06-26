class ManageDocumentService < CrudService

  def initialize(document = nil)
    if document
      @document = document
      super('Document', document)
    else
      super('Document')
    end
  end

end
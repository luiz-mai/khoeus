class ManageLinkService < CrudService

  def initialize(link = nil)
    if link
      @link = link
      super('Link', link)
    else
      super('Link')
    end
  end

end
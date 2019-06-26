class ManagePresenceService < CrudService

  def initialize(presence = nil)
    if presence
      @presence = presence
      super('Presence', presence)
    else
      super('Presence')
    end
  end

end
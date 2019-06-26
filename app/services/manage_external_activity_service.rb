class ManageExternalActivityService < CrudService

  def initialize(external_activity = nil)
    if external_activity
      @external_activity = external_activity
      super('ExternalActivity', external_activity)
    else
      super('ExternalActivity')
    end
  end

end
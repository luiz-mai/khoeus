class ManageLogService

  def initialize(log)
    @log = log
  end

  def create
    @log.save
  end

end
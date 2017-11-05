class ManageActivityService < CrudService

  def initialize(activity = nil)
    if activity
      @activity = activity
      super('Activity', activity)
    else
      super('Activity')
    end
  end

  def update_grade(grade)
    @activity.update_attribute(:grade, grade)
  end

end
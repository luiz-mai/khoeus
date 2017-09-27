class ManageSubscriptionService < CrudService

  def initialize(subscription = nil)
    if subscription
      @subscription = subscription
      super('Subscription', subscription)
    else
      super('Subscription')
    end
  end

end
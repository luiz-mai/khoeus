class ManageSubscriptionService

  def initialize(subscription)
    @subscription = subscription
  end

  def create
    @subscription.save
  end

end
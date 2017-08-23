module Helpers
  def log_in(user)
    allow(controller).to receive(:current_user) { user }
  end
end
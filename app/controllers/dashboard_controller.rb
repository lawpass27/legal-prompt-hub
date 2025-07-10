class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @recent_prompts = current_user.legal_prompts.includes(:tags).recent.limit(5)
  end
end

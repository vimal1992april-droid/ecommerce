class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!  # Devise helper for admin
  layout "admin"
  
  def index
    # your admin dashboard logic
  end
end

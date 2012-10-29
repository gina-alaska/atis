class WelcomeController < ApplicationController
  def index
  end
  
  def submit
    current_user.update_attribute(:active_dashboard, 'submitter')
    redirect_to root_path
  end
  
  def review
    current_user.update_attribute(:active_dashboard, 'review')
    redirect_to root_path
  end
end

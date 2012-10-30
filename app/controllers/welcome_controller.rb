class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :authenticate_admin!, :only => [:admin]
  
  
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
  
  def admin
    current_user.update_attribute(:active_dashboard, 'admin')
    redirect_to root_path
  end
end

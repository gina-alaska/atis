class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  helper_method :user_signed_in?
  
  before_filter :authenticate_user!
  
  protected
    
    def current_user  
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  
    end
    
    def current_member
      @current_member ||= (current_user.try(:membership) || Member.new)
    end
    
    def user_signed_in?
      return true if current_user 
    end
      
    def authenticate_user!
      if !current_user
        flash[:error] = 'You need to sign in before accessing this page!'
        redirect_to signin_path
      end
    end
    
    def authenticate_admin!
      if !current_user or !current_user.has_role?(:admin)
        flash[:error] = "You don't have permission to view this page"
        redirect_to root_url
      end
    end  
end

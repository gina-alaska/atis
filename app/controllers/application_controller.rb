class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :authenticate_user!
  
  protected
    
    def current_user  
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  
    end
    
    def current_user=(user)
      session[:user_id] = user.id
      @current_user = user
    end
    
    def current_member
      @current_member ||= (current_user.try(:membership) || Member.new)
    end
    
    def user_signed_in?
      return true if current_user 
    end
      
    def authenticate_user!
      unless user_signed_in?
        store_location
        flash[:error] = 'You need to sign in before accessing this page!'
        redirect_to signin_path
      end
    end
    
    def authenticate_admin!
      store_location
      if !current_user or !current_user.has_role?(:admin)
        flash[:error] = "You don't have permission to view this page"
        redirect_to root_url
      end
    end  
    
    def store_location
      session[:redirect_back_location] = request.url
    end
    
    def redirect_back_or_default(url)
      if session[:redirect_back_location].present?
        l = session.delete(:redirect_back_location)
        redirect_to l
      else
        redirect_to url
      end
    end    
    
    def unauthorized
      render status: 401, template: "/errors/unauthorized.html.haml"
      false
    end

    def not_found
      render status: 404, template: "/errors/not_found.html.haml"
      false
    end
    
    helper_method :current_member
    helper_method :current_user
    helper_method :user_signed_in?  
end

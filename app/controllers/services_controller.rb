class ServicesController < ApplicationController
  skip_before_filter :authenticate_user!
  protect_from_forgery :except => :create     

  def create
    if @auth = Service.find_from_hash(auth_hash, request.host)
      signin_success(@auth, true)
    else
      if @auth = Service.create_from_hash(auth_hash, current_user, request.host)
        signin_success(@auth)
      else
        flash[:error] = "Previous credentials was found that doesn't match the current one"
        redirect_to root_url
      end
    end    
  end
  
  def destroy
    reset_session
    flash[:success] = 'Signed out!'
    if params[:redirect].present?
      redirect_to params[:redirect]
    else
      redirect_back_or_default(root_url)
    end
  end
  
  def new
    redirect_to('/auth/gina')
  end
  
  def failure
    flash[:error] = "Authentication error: #{params[:message].humanize}"
    redirect_to root_url
  end
  
  protected
  
  def signin_success(auth, auto = false)
    self.current_user = auth.user
    check_membership
    
    if auto
      flash[:success] = "You were automatically signed in as #{current_user.name} using #{auth.provider.upcase} authentication"
    else
      flash[:success] = "Successfully signed in as #{current_user.name} using #{auth.provider.upcase} authentication"
    end
    
    case(auth.provider)
    when 'gina'
      flash[:success] += ', if this is incorrect <a href="'+ signout_url(redirect: 'http://id.gina.alaska.edu/logout') +'" target="_blank">click here</a> to logout of the GINA Authentication service and then try again'
    when 'google'
      flash[:success] += ', if this is incorrect please visit <a href="http://google.com">Google</a> and login using the desired account before trying again.'
    end
    
    redirect_back_or_default(root_url)
  end
  
  def auth_hash
    request.env['omniauth.auth']
  end
  
  def check_membership
    if user_signed_in? and current_user.membership.nil?
      member = Member.where(email: current_user.email).first
      if member.nil?
        member = Member.new(name: current_user.name, email: current_user.email)
      end
      current_user.membership = member
    end
  end
end
class UsersController < ApplicationController
  before_filter :authenticate_admin!
  before_filter :fetch_user, :only => [:edit, :update]
  
  def index
    @users = User.all
  end
  
  def edit
  end
  
  def update
    @user.roles = user_params[:roles]
    respond_to do |format|
      if @user.save
        format.html do
          flash[:success] = "Updated permissions for #{@user.name}"
          redirect_to users_path
        end
      end
    end
  end

  protected
  
  def user_params
    p = params[:user].slice(:roles, :agency_id)
    p['roles'] = p['roles'].collect { |k,v| Role.where(name: k).first if v.to_i == 1 }.compact
    p
  end
  
  def fetch_user
    @user = User.find(params[:id])
  end
end

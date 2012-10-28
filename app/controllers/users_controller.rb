class UsersController < ApplicationController
  before_filter :authenticate_admin!
  before_filter :fetch_user, :only => [:edit, :update]
  
  def index
    @users = User.all
  end
  
  def edit
  end
  
  protected
  
  def fetch_user
    @user = User.find(params[:id])
  end
end

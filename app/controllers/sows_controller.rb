class SowsController < ApplicationController
  respond_to :html
  
  before_filter :fetch_sow, :except => [:index, :new, :create]
  
  def index
    @sows = Sow.owner(current_user).created.all
    @pending_review = Sow.owner(current_user).pending_review.all
  end
  
  def show
    respond_with @sow
  end
  
  def submit
    if @sow.submit
      flash[:success] = 'Statement of work has been submitted for review'
    else
      flash[:error] = 'There was an error trying to submit statement of work for review'
    end
    Activity.record(current_user, 'submitted', @sow)
    
    
    respond_to do |format|
      format.html {
        redirect_to root_path
      }
    end
  end
  
  def review
    @sow.review    
    respond_to do |format|
      format.html {
        redirect_to sow_path(@sow)
      }
    end
  end
  
  def accept
    if @sow.accept
      respond_to do |format|
        format.html {
          flash[:success] = "Statement of work has been accepted"
          redirect_to root_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Error while trying to accept statement of work"
          render :show
        }
      end
    end
  end
  
  def reject
    if @sow.reject
      respond_to do |format|
        format.html {
          flash[:success] = "Statement of work has been rejected"
          redirect_to root_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "Error while trying to reject statement of work"
          render :show
        }
      end
    end
  end
  
  def new
    @sow = Sow.new
    @sow.first_name = current_user.first_name
    @sow.last_name = current_user.last_name
    @sow.email = current_user.email
    
    respond_with @sow
  end
  
  def create
    @sow = Sow.new(params[:sow])
    @sow.user = current_user
    
    if @sow.save
      respond_to do |format|
        format.html {
          flash[:success] = "Statement of work has been saved"
          redirect_to root_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "There was an error while trying to save your statement of work"
          render :action => :new
        }
      end
    end
  end
  
  def edit
    respond_with @sow
  end
  
  def update
    if @sow.update_attributes(params[:sow])
      respond_to do |format|
        format.html {
          flash[:success] = "Statement of work has been saved"
          redirect_to root_path
        }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = "There was an error while trying to save your statement of work"
          render :action => :edit
        }
      end
    end
  end
  
  protected
  
  def fetch_sow
    @sow = Sow.find(params[:id]) if params[:id].present?
  end
end

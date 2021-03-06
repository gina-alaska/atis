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
    if @sow.submit(current_user)
      flash[:success] = 'Statement of work has been submitted for review'
      redirect_to @sow
    else
      flash[:error] = 'There was an error trying to submit statement of work for review'
      redirect_to root_path
    end    
  end
  
  def review
    if @sow.review(current_user)
      redirect_to @sow
    else
      flash[:error] = "There was an error while trying to review statement of work (#{@sow.errors.full_message})"
      redirect_to root_path
    end
  end
  
  def accept
    if @sow.accept(current_user)
      flash[:success] = "Statement of work has been accepted"
      redirect_to @sow
    else
      flash[:error] = "Error while trying to accept statement of work"
      redirect_to root_path
    end
  end
  
  def reject
    if @sow.reject(current_user)
      flash[:success] = "Statement of work has been rejected"
      redirect_to @sow
    else
      flash[:error] = "Error while trying to reject statement of work"
      redirect_to root_path
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
    @sow = Sow.new(sow_params)
    @sow.user = current_user
    
    if @sow.save
      flash[:success] = "Statement of work has been saved"
      if params[:continue].to_i == 1
        redirect_to edit_sow_path(@sow)
      else
        redirect_to @sow
      end
    else
      flash[:error] = "There was an error while trying to save your statement of work"
      render :action => :new
    end
  end
  
  def edit
    if @sow.edit(current_user)
      respond_with @sow
    else
      flash[:error] = 'Unable to edit the statement of work at this time'
      redirect_to root_path
    end
  end
  
  def update
    if @sow.update_attributes(sow_params)
      flash[:success] = "Statement of work has been saved"
      if params[:continue].to_i == 1
        redirect_to edit_sow_path(@sow)
      else
        redirect_to @sow
      end
    else
      flash[:error] = "There was an error while trying to save your statement of work"
      render :action => :edit
    end
  end
  
  protected
  
  def sow_params
    p = params[:sow]
    
    if p[:disciplines].present?
      discs = p.delete(:disciplines)
      p[:disciplines] ||= [] 
      discs.each do |id|
        next if id.to_i == 0
        d = Discipline.find(id.to_i) 
        p[:disciplines] << d unless d.nil?
      end
    end
    
    logger.info '************'
    logger.info p.inspect
    
    p
  end
  
  def fetch_sow
    @sow = Sow.find(params[:id]) if params[:id].present?
  end
end

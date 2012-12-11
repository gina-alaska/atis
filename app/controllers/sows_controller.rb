class SowsController < ApplicationController
  respond_to :html
  
  before_filter :fetch_sow, :except => [:index, :new, :create]
  
  def index
  end
  
  def show
    respond_with @sow
  end
  
  def submit_dashboard
    current_user.update_attribute(:active_dashboard, 'submitter')
    redirect_to sows_path
  end
  
  def review_dashboard
    current_user.update_attribute(:active_dashboard, 'review')
    redirect_to sows_path
  end
  
  def admin_dashboard
    current_user.update_attribute(:active_dashboard, 'admin')
    redirect_to sows_path
  end
  
  
  def submit
    if @sow.submit(current_user)
      flash[:success] = 'Statement of work has been submitted for review'
      redirect_to @sow
    else
      flash[:error] = 'There was an error trying to submit statement of work for review'
      redirect_to sows_path
    end    
  end
  
  def review
    if @sow.review(current_user)
      redirect_to @sow
    else
      flash[:error] = "There was an error while trying to review statement of work (#{@sow.errors.full_message})"
      redirect_to sows_path
    end
  end
  
  def group_approve
    if @sow.group_leader_approval.nil?
      flash[:success] = "Statement of work has been approved by #{current_user.name}"
      @sow.group_leader_approval = current_user
    else
      flash[:warning] = "Statement of work approval has been removed by #{current_user.name}"
      @sow.group_leader_approval = nil
    end
    
    if @sow.save
      redirect_to @sow
    else
      flash[:error] = "Error while trying to approve statement of work"
      redirect_to sows_path
    end
  end
  
  def pi_approve
    if @sow.pi_approval.nil?
      flash[:success] = "Statement of work has been approved by #{current_user.name}"
      @sow.pi_approval = current_user
    else
      flash[:warning] = "Statement of work approval has been removed by #{current_user.name}"
      @sow.pi_approval = nil
    end
    
    if @sow.save
      redirect_to @sow
    else
      flash[:error] = "Error while trying to approve statement of work"
      redirect_to sows_path
    end
  end
  
  def accept
    if @sow.accept(current_user)
      flash[:success] = "Statement of work has been accepted"
      redirect_to @sow
    else
      flash[:error] = "Error while trying to accept statement of work"
      redirect_to sows_path
    end
  end
  
  def reject
    notes = @sow.review_notes + "\n\n#{sow_params[:review_notes]} - _#{current_user.name_email} @ #{Time.zone.now.strftime('%F')}_"
    
    if @sow.reject(current_user, notes)
      flash[:success] = "Statement of work has been rejected"
      redirect_to @sow
    else
      flash[:error] = "Error while trying to reject statement of work"
      redirect_to sows_path
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
      redirect_to sows_path
    end
  end
  
  def update
    if sow_params.delete(:rejected)
      reject
    else
      logger.info '*******'
      logger.info sow_params.inspect
      logger.info '*******'

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
  end
  
  protected
  
  def sow_params
    p = params[:sow].dup
    
    if p[:disciplines].present?
      discs = p.delete(:disciplines)
      p[:disciplines] = [] 
      
      discs.each do |id|
        next if id.to_i == 0
        d = Discipline.find(id.to_i) 
        p[:disciplines] << d unless d.nil?
      end
    end
    
    p
  end
  
  def fetch_sow
    @sow = Sow.find(params[:id]) if params[:id].present?
  end
end

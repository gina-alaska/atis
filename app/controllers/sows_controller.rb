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
    if @sow.submit(current_member)      
      flash[:success] = 'Statement of work has been submitted for review'
      MemberMailer.review_email(@sow.award_group.members, @sow, sow_url(@sow)).deliver
      
      redirect_to @sow
    else
      flash[:error] = "There was an error trying to submit statement of work for review<br/><ul>"
      @sow.errors.full_messages.each do |m| 
        flash[:error] << "<li>#{m}</li>"
      end
      flash[:error] << '</ul>'
      redirect_to @sow
    end    
  end
  
  def review
    unless @sow.ready_for_review?
      flash[:error] = "This statement of work is not ready for review"
    end
    redirect_to @sow
    # if @sow.review(current_member)
    #   redirect_to @sow
    # else
      # flash[:error] = "There was an error while trying to review statement of work (#{@sow.errors.full_messages})"
      # redirect_to @sow
    # end
  end
  
  def pa_approve
    respond_to do |format|
      format.html {
        if @sow.approvals.for(:administrator).any?
          # @sow.approvals.for(:administrator).destroy_all
          @sow.groupleader_accept
        elsif @sow.can_administrator_accept?
          @sow.approvals.create(user: current_member, name: 'administrator')
          @sow.review_notes = sow_params[:review_notes]
          @sow.administrator_accept
          @sow.save
          
          # TODO: Budget review email would need to go out now
          @members = @sow.award_group.top.members.joins(:roles).where('roles.name = ?', 'budget').all
          MemberMailer.review_email(@members, @sow, sow_url(@sow)).deliver
        end
        
        flash[:success] = "Statement of work has been approved by #{current_member.name}"
        redirect_to @sow
      }
      format.js { 
        @approval_type = 'administrator'
        render 'approve' 
      }
    end
  end  
  
  def budget_approve
    respond_to do |format|
      format.html {
        if @sow.approvals.for(:budget).any?
          # @sow.approvals.for(:budget).destroy_all
          @sow.administrator_accept
        elsif @sow.can_accept_budget?
          @sow.approvals.create(user: current_member, name: 'budget')
          @sow.review_notes = sow_params[:review_notes]
          @sow.accept_budget
          
          @sow.save
          
          # TODO: PI review email would need to go out now
          @members = @sow.award_group.top.members.joins(:roles).where('roles.name = ?', 'review').all
          MemberMailer.review_email(@members, @sow, sow_url(@sow)).deliver
        end
        
        flash[:success] = "Statement of work budget has been approved by #{current_member.name}"
        redirect_to @sow
      }
      format.js { 
        @approval_type = 'budget'
        render 'approve' 
      }
    end
  end
  
  def group_approve
    approvals = @sow.approvals.for(@sow.award_group.name)
    if approvals.any?
      flash[:warning] = "Statement of work approval has been removed by #{current_member.name}"
      @sow.submit(current_member)
      
    elsif @sow.can_groupleader_accept? and @sow.award_group.member_ids.include?(current_member.id)
      flash[:success] = "Statement of work has been approved by #{current_member.name}"
      
      @sow.approvals.create(user: current_member, name: @sow.award_group.name)
      @sow.review_notes = sow_params[:review_notes]
      @sow.groupleader_accept
      @sow.save
      
      # TODO: PA Approval email would need to go out now
      @members = @sow.award_group.top.members.joins(:roles).where('roles.name = ?', 'project administrator').all
      MemberMailer.review_email(@members, @sow, sow_url(@sow)).deliver
    end    
    redirect_to @sow
  end
  
  def pi_approve
    approvals = @sow.approvals.for(@sow.award_group.top.name)
    if approvals.any?
      flash[:warning] = "Statement of work approval has been removed by #{current_member.name}"
      # approvals.destroy_all
      @sow.accept_budget
    else
      flash[:success] = "Statement of work has been approved by #{current_member.name}"
      
      @sow.approvals.create(user: current_member, name: @sow.award_group.top.name)
      @sow.review_notes = sow_params[:review_notes]
      @sow.projectleader_accept
      @sow.save

      # TODO: Ready to award email would need to go out now
      @members = @sow.award_group.top.members.joins(:roles).where('roles.name' => ['project administrator', 'budget']).all
      MemberMailer.award_email(@members, @sow, sow_url(@sow)).deliver
    end
    redirect_to @sow    
  end
  
  def new_award
    if @sow.generate_award(current_member) and @sow.save
      @award = @sow.award
      # TODO: Generate awarded email
      # MemberMailer.awarded_email(@award, award_url(@award)).deliver      
      flash[:success] = "New award has been generated"
      redirect_to edit_award_path(@award)
    else
      flash.now[:error] = "Error while trying to create a new award"
      render 'show'
    end
  end
  
  def reject
    @sow.reject(current_member)
    @sow.review_notes = sow_params[:review_notes]
    @sow.reviewed_by = current_member
    
    if @sow.save 
      
      # TODO: Generate rejection email
      MemberMailer.rejection_email(@sow.owner, @sow, sow_url(@sow)).deliver
      
      flash[:success] = "Statement of work has been rejected"
      redirect_to @sow
    else
      flash[:error] = "Error while trying to reject statement of work"
      redirect_to sows_path
    end
  end
  
  def new
    @sow = Sow.new
    @sow.first_name = current_member.first_name
    @sow.last_name = current_member.last_name
    @sow.email = current_member.email
    
    respond_with @sow
  end
  
  def create
    @sow = Sow.new(sow_params)
    @sow.owner = current_member
    
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
    if @sow.edit(current_member)
      respond_with @sow
    else
      flash[:error] = 'Unable to edit the statement of work at this time'
      redirect_to sows_path
    end
  end
  
  def update
    if sow_params.delete(:rejected)
      reject
    elsif sow_params.delete(:pi_approval)
      pi_approve
    elsif sow_params.delete(:gl_approval)
      group_approve
    elsif type = sow_params.delete(:approval_type)
      case type
      when 'administrator'
        pa_approve
      when 'budget'
        budget_approve
      else
        flash[:error] = "Unknown approval type #{type}"
        redirect_to @sow
      end
    else
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
    
    if p[:review_notes].present? and !p[:review_notes].empty?
      p[:review_notes] = "#{p[:review_notes]} - _#{current_member.name_with_email} @ #{Time.zone.now.strftime('%F')}_"
    end
    
    if p[:strategic_objectives].present? and !p[:strategic_objectives].empty?
      p[:strategic_objective_ids] = p.delete(:strategic_objectives).collect do |id, value|
        id if value.to_i
      end
    end
    
    p
  end
  
  def fetch_sow
    @sow = Sow.find(params[:id]) if params[:id].present?
  end
end

class MemberMailer < ActionMailer::Base
  default from: "support@gina.alaska.edu"
  helper SowsHelper
  layout 'email'
  
  def invite_email(member, url)
    @member = member
    @url = url
    
    mail(:to => member.email, subject: "[ATIS::Invitation] You have been invited to join the Award Tracking Information System (ATIS)")
  end
  
  def changed_attributes(member, changes)
    @member = member
    @changes = changes
    mail(:to => member.email, subject: "[ATIS::Account changes] Account settings updated")
  end
  
  def review_email(members, sow, url)
    @sow = sow
    @url = url
    @members = members
    
    if @members.empty?
      logger.error "ERROR: No members given for the review email"
      return false 
    end
    
    mail(:to => @members.collect(&:email), subject: "[ATIS::SOW Review] Statement of work is ready to be reviewed")
  end
  
  def award_email(members, sow, url)
    @sow = sow
    @url = url
    @members = members
    
    if @members.empty?
      logger.error "ERROR: No members given for the review email"
      return false 
    end
    
    mail(:to => @members.collect(&:email), subject: "[ATIS::Ready to Award] Statement of work is ready to be awarded")
  end
  
  def rejection_email(member, sow, url)
    @sow = sow
    @url = url
    @member = member
    
    if @member.nil?
      logger.error "ERROR: No members given for the review email"
      return false 
    end
    
    mail(:to => @member.email, subject: "[ATIS::SOW Rejection] Your statement of work has been rejected")    
  end
end

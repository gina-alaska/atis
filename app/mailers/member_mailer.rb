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
    mail(:to => member.email, subject: "[ATIS::Account Settings] Account settings updated")
  end
  
  def review_email(members, sow, url)
    @sow = sow
    @url = url
    @members = members
    
    if @members.empty?
      logger.error "ERROR: No members given for the review email"
      return false 
    end
    
    mail(:to => @members.collect(&:email), subject: "[ATIS::Review] Statement of work is ready to be reviewed")
  end
  
  def award_email(members, sow, url)
    @sow = sow
    @url = url
    @members = members
    
    if @members.empty?
      logger.error "ERROR: No members given for the review email"
      return false 
    end
    
    mail(:to => @members.collect(&:email), subject: "[ATIS::Award] Statement of work is ready to be awarded")
  end
  
  def rejection_email(sow, url)
    @sow = sow
    @url = url
    @members = members
    
    if @members.empty?
      logger.error "ERROR: No members given for the review email"
      return false 
    end
    
    mail(:to => @members.collect(&:email), subject: "[ATIS] Your statement of work has been rejected")    
  end
end

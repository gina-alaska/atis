class MemberMailer < ActionMailer::Base
  default from: "support@gina.alaska.edu"
  layout 'email'
  
  def invite_email(member, url)
    @member = member
    @url = url
    
    mail(:to => member.email, subject: "[ATIS] You have been invited to join the Award Tracking Information System (ATIS)")
  end
  
  def changed_attributes(member, changes)
    @member = member
    @changes = changes
    mail(:to => member.email, subject: "[ATIS] Account settings updated")
  end
  
  def review_email(members, sow, url)
    @sow = sow
    @url = url
    @members = members
    
    if @members.empty?
      logger.error "ERROR: No members given for the review email"
      return false 
    end
    
    mail(:to => @members.collect(&:email), subject: "[ATIS] Statement of work is ready to be reviewed")
  end
  
  def reject_email(sow, url)
    
  end
end

class ExceptionMailer < ActionMailer::Base
  default from: "support@gina.alaska.edu"
  layout 'email'
  
  def notify(exception, request)
    @exception = exception
    @request = request
    mail(:to => 'alerts@gina.alaska.edu', subject: "[ATIS::ERROR] An error occured in the ATIS application")
  end
end

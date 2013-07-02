class ErrorsController < ApplicationController
  # Will render the app/views/errors/unauthorized.html.haml template
  def unauthorized
    ExceptionMailer.notify(the_exception, request).deliver
    render :status => 401, :formats => [:html]
  end

  # Will render the app/views/errors/not_found.html.haml template
  def not_found
    ExceptionMailer.notify(the_exception, request).deliver
    render :status => 404, :formats => [:html]
  end


  # Will render the app/views/errors/error.html.haml template
  def error
    ExceptionMailer.notify(the_exception, request).deliver
    render :status => 500, :formats => [:html]
  end

  protected

  # The exception that resulted in this error action being called can be accessed from
  # the env. From there you can get a backtrace and/or message or whatever else is stored
  # in the exception object.
  def the_exception
    @e ||= env["action_dispatch.exception"]
  end
end

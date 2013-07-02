class ErrorsController < ApplicationController
  def unauthorized
    # Will render the app/views/errors/unauthorized.html.haml template
  end

  def not_found
    # Will render the app/views/errors/not_found.html.haml template
  end

  def error
    # Will render the app/views/errors/error.html.haml template
  end

  protected

  # The exception that resulted in this error action being called can be accessed from
  # the env. From there you can get a backtrace and/or message or whatever else is stored
  # in the exception object.
  def the_exception
    @e ||= env["action_dispatch.exception"]
  end
end

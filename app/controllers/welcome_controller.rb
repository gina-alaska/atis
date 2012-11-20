class WelcomeController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  before_filter :authenticate_admin!, :only => [:admin]
  
  
  def index
  end  
end

class SowsController < ApplicationController
  respond_to :html
  
  def new
    @sow = Sow.new
    
    respond_with @sow
  end
end

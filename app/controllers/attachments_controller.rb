class AttachmentsController < ApplicationController
  before_filter :fetch_sow
  
  def index
    @attachments = @sow.attachments.all
    
    respond_to do |format|
      format.html {
        render :layout => false if request.xhr?
      }
    end
  end
  
  def create
    file = params[:attachment][:file].shift
        
    @attachment = @sow.attachments.where(name: File.basename(file.original_filename)).first
    
    if @attachment.nil?
      @attachment = @sow.attachments.build
      @attachment.name = File.basename(file.original_filename)
    else
      @attachment.remove_file
    end
    @attachment.file = file      
    
    if @attachment.save
      respond_to do |format|
        format.html {                                         
          #(html response is for browsers using iframe sollution)
          render :json => [@attachment.to_jq_upload].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json {
          render :json => [@attachment.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end
  
  protected
  
  def fetch_sow
    @sow = Sow.find(params[:sow_id])
  end
end

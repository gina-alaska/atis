class Attachment < ActiveRecord::Base
  attr_accessible :file_uid, :file
  
  belongs_to :parent, :polymorphic => true
  
  file_accessor :file
  
  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
    {
      "name" => read_attribute(:file),
      "url" => file.url
    }
  end
end

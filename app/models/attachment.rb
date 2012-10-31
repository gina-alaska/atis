class Attachment < ActiveRecord::Base
  attr_accessible :file_uid, :file
  
  belongs_to :parent, :polymorphic => true
  
  file_accessor :file
end

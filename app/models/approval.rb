class Approval < ActiveRecord::Base
  attr_accessible :name, :sow_id, :user_id, :user
  
  belongs_to :sow
  belongs_to :user, class_name: 'Member'
end

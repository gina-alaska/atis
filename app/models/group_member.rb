class GroupMember < ActiveRecord::Base
  attr_accessible :group_id, :member_id
  
  belongs_to :group
  belongs_to :member
end

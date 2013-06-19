class StrategicObjective < ActiveRecord::Base
  attr_accessible :name, :group, :group_id
  
  belongs_to :group
  
  validates_uniqueness_of :name, scope: :group_id
end

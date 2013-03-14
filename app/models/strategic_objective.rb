class StrategicObjective < ActiveRecord::Base
  attr_accessible :name
  
  belongs_to :group
  
  validates_uniqueness_of :name, scope: :group_id
end

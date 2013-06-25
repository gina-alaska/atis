class StrategicObjective < ActiveRecord::Base
  attr_accessible :name, :group, :group_id
  
  belongs_to :group
  has_and_belongs_to_many :sows
  
  validates_uniqueness_of :name, scope: :group_id
end

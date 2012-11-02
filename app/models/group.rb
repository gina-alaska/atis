class Group < ActiveRecord::Base
  attr_accessible :acronym, :director_id, :fiscal_coordinator_id, :name, :parent, :top
  
  belongs_to :parent, class_name: 'Group'
  belongs_to :top, class_name: 'Group'
  
  has_many :children, class_name: 'Group', foreign_key: 'parent_id'
  
  before_save :assign_top_group
  
  def assign_top_group
    if self.top.nil? and self.parent.try(:top)
      self.top = self.parent.top
    end
  end
end

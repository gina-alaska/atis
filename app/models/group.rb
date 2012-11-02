class Group < ActiveRecord::Base
  attr_accessible :acronym, :director_id, :fiscal_coordinator_id, :name, :parent, :top
  
  belongs_to :parent, class_name: 'Group'
  belongs_to :top, class_name: 'Group'
  
  has_many :children, class_name: 'Group', foreign_key: 'parent_id', dependent: :destroy
  
  before_save :assign_top_group
  
  def assign_top_group
    if self.top.nil?
      if self.parent and self.parent.try(:top)
        self.top = self.parent.top
      else
        self.top = self.parent
      end
    end
  end
end

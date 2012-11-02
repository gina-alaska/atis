class Group < ActiveRecord::Base
  attr_accessible :acronym, :director_id, :fiscal_coordinator_id, :name, :parent_id, :top
  
  belongs_to :parent, class_name: 'Group'
  belongs_to :top, class_name: 'Group'
  
  has_many :children, class_name: 'Group', foreign_key: 'parent_id', dependent: :destroy
  has_many :all_children, class_name: 'Group', foreign_key: 'top_id'
  
  before_save :assign_top_group
  
  scope :top, where(:parent_id => nil)
  
  def assign_top_group
    if self.top.nil?
      if self.parent and self.parent.try(:top)
        self.top = self.parent.top
      else
        self.top = self.parent
      end
    end
  end
  
  def name_path
    if self.parent
      "#{self.parent.name_path} &rarr; #{self.name}".html_safe
    else
      self.name
    end
  end
end

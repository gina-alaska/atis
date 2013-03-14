class Group < ActiveRecord::Base
  attr_accessible :acronym, :director_id, :fiscal_coordinator_id, :name, :parent_id, :top, :strategic_objectives_attributes
  
  belongs_to :parent, class_name: 'Group'
  belongs_to :top, class_name: 'Group'
  
  has_many :children, class_name: 'Group', foreign_key: 'parent_id', dependent: :destroy
  has_many :all_children, class_name: 'Group', foreign_key: 'top_id'
  
  belongs_to :fiscal_coordinator, class_name: 'User'
  belongs_to :director, class_name: 'User'
  
  has_many :awards
  
  has_many :strategic_objectives, :dependent => :destroy
  accepts_nested_attributes_for :strategic_objectives, :allow_destroy => true, :reject_if => proc { |attributes| attributes['name'].blank? }
  
  before_save :assign_top_group
  
  scope :top, where(:parent_id => nil)
  
  validates_uniqueness_of :acronym, :scope => :parent_id
  
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
  
  def acronym_path
    if self.parent
      ap = self.parent.acronym_path << self.acronym
    elsif self.acronym
      ap = [self.acronym]
    else
      ap = []
    end
    
    ap.compact
  end
  
  def to_s
    self.name_path
  end
end

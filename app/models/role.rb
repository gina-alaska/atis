class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_and_belongs_to_many :members
  
  attr_accessible :name
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  def to_s
    self.name.humanize
  end
end

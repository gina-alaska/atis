class Discipline < ActiveRecord::Base
  attr_accessible :name
  
  has_and_belongs_to_many :sows
  
  default_scope order('name ASC')
end

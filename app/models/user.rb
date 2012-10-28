class User < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  has_and_belongs_to_many :roles
  has_many :sows
  
  attr_accessible :email, :name
  
  def has_role?(role)
    if role = Role.where(name: role).first
      return self.roles.include? role
    end
    
    false
  end
  
  def first_name
    self.name.split(' ').first
  end
  
  def last_name
    self.name.split(' ').last
  end
end

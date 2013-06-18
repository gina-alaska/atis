class Member < ActiveRecord::Base
  attr_accessible :email, :name, :user_id, :user, :roles_attributes, :roles
  
  belongs_to :user
  has_and_belongs_to_many :roles
  
  def has_role?(role)
    if role = Role.where(name: role).first
      return self.roles.include? role
    end
    
    false
  end
  
  def guest?
    self.new_record? or self.user.nil?
  end
end

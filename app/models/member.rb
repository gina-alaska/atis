class Member < ActiveRecord::Base
  attr_accessible :email, :name, :user_id, :user, :roles_attributes, :roles
  
  belongs_to :user, dependent: :destroy
  has_and_belongs_to_many :roles, uniq: true
  
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def has_role?(*roles)
    self.roles.where(name: roles).any?
  end
  
  def first_name
    self.name.split(' ').first
  end
  
  def last_name
    self.name.split(' ').last
  end
  
  def to_s
    self.name_with_email
  end
  
  def name_with_email
    "#{self.name} <#{self.email}>"
  end
  
  def guest?
    self.new_record? or self.user.nil?
  end
end

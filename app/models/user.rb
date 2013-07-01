class User < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  # has_and_belongs_to_many :roles
  has_many :sows
  has_many :activities, as: 'subject', :dependent => :destroy
  has_many :approvals
  has_one :membership, class_name: 'Member'
  
  attr_accessible :email, :name
  
  delegate :roles, to: :membership
  
  validates_uniqueness_of :email

  before_save :downcase_email
  
  def downcase_email
    self.email.downcase!
  end
  
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
  
  def name_email
    "#{self.name} <#{self.email}>"
  end
  
  def to_s
    self.name_email
  end
  
  def self.create_or_find_from_hash!(hash)
    user = where(email: hash['info']['email'].downcase).first
    user = create!(:name => hash['info']['name'], :email => hash['info']['email'].downcase) if user.nil?
    
    user
  end
end

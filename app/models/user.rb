class User < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  
  attr_accessible :email, :name
end

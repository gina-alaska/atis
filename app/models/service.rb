class Service < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :provider, :uemail, :uid, :uname, :user_id, :user, :host
  
  # don't allow more than one uid(google token) from the same provider and host
  validates_uniqueness_of :uid, :scope => [:provider,:host]
  # don't allow more than one user id more than once with same host and provider
  validates_uniqueness_of :user_id, :scope => [:host, :provider]
  
  def self.find_from_hash(hash, host)
    where(provider: hash['provider'], uid: hash['uid'], host: host).first
  end

  def self.create_from_hash(hash, user = nil, host='')
    user ||= User.create_or_find_from_hash!(hash)
    create(:user => user, :uid => hash['uid'], :provider => hash['provider'], host: host)
  end  
end

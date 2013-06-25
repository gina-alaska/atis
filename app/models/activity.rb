class Activity < ActiveRecord::Base
  attr_accessible :changed_item_id, :changed_item_type, :subject_id, :subject_type, :verb, :subject, :changed_item, :owner
  
  belongs_to :changed_item, polymorphic: true
  belongs_to :subject, polymorphic: true
  belongs_to :owner, :class_name => 'Member'
  
  def self.record(sub, verb, item = nil, owner = nil)
    self.create(subject: sub, verb: verb, changed_item: item, owner: owner)
  end
  
  def full_message
    output = "#{subject.name} #{verb}"
    
    if changed_item
      output << " \"#{changed_item.name}\""
    end
    
    output
  end
end

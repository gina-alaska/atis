class Activity < ActiveRecord::Base
  attr_accessible :changed_item_id, :changed_item_type, :subject_id, :subject_type, :verb, :subject, :changed_item
  
  belongs_to :changed_item, polymorphic: true
  belongs_to :subject, polymorphic: true
  
  def self.record(sub, verb, item = nil)
    self.create(subject: sub, verb: verb, changed_item: item)
  end
  
  def full_message
    output = "#{subject.name} #{verb}"
    
    if changed_item
      output << " \"#{changed_item.name}\""
    end
    
    output
  end
end

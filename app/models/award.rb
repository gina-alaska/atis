class Award < ActiveRecord::Base
  attr_accessible :slug, :title, :account, :budget
  
  state_machine :state, :initial => :created do
    event :present do
      transition :created => :presented
    end
    
    event :accept do
      transition :presented => :accepted
    end
    
    event :complete do
      transition :accepted => :completed
    end
    
    event :cancel do
      transition all - [:completed, :canceled] => :canceled
    end
  end
  
  has_many :sows
  
  validates_presence_of :slug
  validates_uniqueness_of :slug
  validates_presence_of :mau_id
  validates_presence_of :institute
  # validates_presence_of :starts_at
  # validates_presence_of :ends_at
  
  after_create :add_id_to_slug
  
  def to_param
    self.slug
  end
  
  def self.from_sow(sow)
    return nil unless sow.can_accept?
    
    award = Award.create({ 
      slug: generate_slug(sow.group)
    })
    
    award.sows << sow
    award
  end
  
  def self.generate_slug(group)
    [group.acronym_path.join('-'), Time.zone.now.year, rand(1000..9999)].join('-')
  end
  
  def add_id_to_slug
    self.update_attributes(slug: [self.slug, self.id].join('-'))
  end
end

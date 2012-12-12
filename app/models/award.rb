class Award < ActiveRecord::Base
  attr_accessible :description, :group_id, :pi_id, :slug, :title, :pi, :group, :mau_id, :mau, :institute
  
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
  
  belongs_to :pi, class_name: 'User'
  belongs_to :group
  has_many :sows
  
  validates_presence_of :slug
  validates_uniqueness_of :slug
  
  after_create :add_id_to_slug
  
  def to_param
    self.slug
  end
  
  def self.from_sow(sow)
    return nil unless sow.can_accept?
    
    award = Award.create({ 
      slug: generate_slug(sow.group),
      title: sow.project_title,
      description: sow.statement_of_work,
      group: sow.group,
      pi: sow.owner
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

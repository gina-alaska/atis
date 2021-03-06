class Sow < ActiveRecord::Base
  belongs_to :user
  has_many :activities, :as => :changed_item, :dependent => :destroy do
    def for(user)
      where(:owner_id => [nil, user])
    end
  end
  
  has_and_belongs_to_many :disciplines
  has_many :attachments, :as => :parent, :dependent => :destroy
  belongs_to :group
  
  state_machine :initial => :created do
    after_transition :on => :submit do |sow, transition, test|
      sow.touch_date(:submitted_on)
      user = transition.args.first
      sow.submitted_by = user
      Activity.record(user, 'submitted for review', sow, user)
      Activity.record(user, 'submitted for review', sow, sow.user) if sow.user != user
    end
    
    after_transition :on => :accept do |sow, transition|
      sow.touch_date(:accepted_on)
      user = transition.args.first
      sow.reviewed_by = user
      Activity.record(user, 'accepted', sow, user)
      Activity.record(user, 'accepted', sow, sow.user) if sow.user != user
    end
    
    after_transition :on => :reject do |sow, transition|
      sow.touch_date(:rejected_on)
      user = transition.args.first
      sow.reviewed_by = user
      Activity.record(user, 'rejected', sow, user)
      Activity.record(user, 'rejected', sow, sow.user) if sow.user != user
    end
    
    before_transition :on => :edit do |sow, transition|
      user = transition.args.first
      unless sow.editing?
        Activity.record(user, 'edited', sow, user)
        Activity.record(user, 'edited', sow, sow.user) if sow.user != user
      end
    end
    
    event :edit do
      transition [:created, :editing, :submitted, :rejected] => :editing
    end
    
    event :review do
      transition [:submitted, :reviewing] => :reviewing
    end
    
    event :submit do
      transition [:created, :editing] => :submitted
    end
    
    event :accept do
      transition :reviewing => :accepted
    end
    
    event :reject do
      transition :reviewing => :rejected
    end
  end

  attr_accessible :email, :first_name, :last_name, :other_strategic_objective, :period, :other_period, :telephone, 
    :project_title, :ua_number, :statement_of_work, :collaborators, :research_milestones_and_outcomes, 
    :accomplished_objectives, :budget_justification, :research_period_of_performance, :climate_glacier_dynamics,
    :ecosystem_variability, :resource_management, :other_strategic_objectives, :other_strategic_objectives_text,
    :disciplines, :group_id

  validates_presence_of :first_name, :last_name, :email, :period, :project_title, :statement_of_work, :ua_number, :user
  validates_presence_of :group_id
  validates_presence_of :other_period, :if => Proc.new { |sow| sow.period == 'other' }
  
  
  scope :owner, lambda { |user| where(user_id: user) }
  scope :unsubmitted, where(:state => [:created, :editing])
  scope :submitted, where(:state => [:submitted, :reviewing])
  scope :accepted, where(:state => :accepted)
  scope :rejected, where(:state => :rejected)
  scope :active, where(:state => [:created, :rejected])
  default_scope order('created_at DESC')
  
  STRATEGIC_OBJECTIVES = { 
    :climate_glacier_dynamics => "Climate/Glacier Dynamics", 
    :ecosystem_variability => "Ecosystem Variability", 
    :resource_management => "Resource Management",
    :other_strategic_objectives => "Other"
  }
  
  def to_param
    "#{id}-#{self.project_title.parameterize}"
  end
  
  def touch_date(field)
    self.update_attribute(field, Time.zone.now)
  end
  
  def strategic_objectives
    active = []
    Sow::STRATEGIC_OBJECTIVES.each do |k,v| 
      if self.send(k)
        active << (k == :other_strategic_objectives ? self.other_strategic_objectives_text : v)
      end
    end
    
    active
  end
  
  def name
    self.project_title
  end
end

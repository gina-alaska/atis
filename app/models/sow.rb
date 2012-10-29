class Sow < ActiveRecord::Base
  belongs_to :user
  has_many :activities, :as => :changed_item, :dependent => :destroy
  
  state_machine :initial => :created do
    after_transition :on => :submit do |sow, transition, test|
      sow.touch_date(:submitted_on)
      user = transition.args.first
      sow.submitted_by = user
      Activity.record(user, 'submitted', sow)
    end
    
    after_transition :on => :accept do |sow, transition|
      sow.touch_date(:accepted_on)
      user = transition.args.first
      sow.reviewed_by = user
      Activity.record(user, 'accepted', sow)
    end
    
    after_transition :on => :reject do |sow, transition|
      sow.touch_date(:rejected_on)
      user = transition.args.first
      sow.reviewed_by = user
      Activity.record(user, 'rejected', sow)
    end
    
    event :review do
      transition [:submitted, :accepted, :rejected] => :reviewing
    end
    
    event :submit do
      transition [:created, :rejected] => :submitted
    end
    
    event :accept do
      transition :reviewing => :accepted
    end
    
    event :reject do
      transition :reviewing => :rejected
    end
  end

  attr_accessible :email, :first_name, :last_name, :other_strategic_objective, :period, :other_period, :telephone, :project_title, :ua_number, :statement_of_work,
  :collaborators, :research_milestones_and_outcomes, :accomplished_objectives, :budget_justification, :research_period_of_performance

  validates_presence_of :first_name, :last_name, :email, :period, :project_title, :statement_of_work, :ua_number, :user
  validates_presence_of :other_period, :if => Proc.new { |sow| sow.period == 'other' }
  
  scope :owner, lambda { |user| where(user_id: user) }
  scope :pending_review, where(:state => :submitted)
  scope :active, where(:state => [:created, :rejected])
  
  def touch_date(field)
    self.update_attribute(field, Time.now)
  end
  
  def name
    self.project_title
  end
end

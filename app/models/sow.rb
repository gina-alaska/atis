class Sow < ActiveRecord::Base
  has_many :activities, :as => :changed_item, :dependent => :destroy do
    def for(user)
      where(:owner_id => [nil, user])
    end
  end
  
  has_and_belongs_to_many :disciplines
  has_and_belongs_to_many :strategic_objectives do
    def list
      self.pluck(:name).join(', ')
    end
  end
  has_many :attachments, :as => :parent, :dependent => :destroy
  belongs_to :award_group, class_name: 'Group'
  belongs_to :pi_approval, :class_name => 'Member'
  belongs_to :group_leader_approval, :class_name => 'Member'
  belongs_to :submitted_by, :class_name => 'Member'
  belongs_to :reviewed_by, :class_name => 'Member'
  belongs_to :owner, :class_name => 'Member'
  belongs_to :award
  belongs_to :mau
  has_many :approvals, :dependent => :destroy do        
    def for(name)
      where(name: name.to_s)
    end
  end
  
  state_machine :initial => :created do
    before_transition :on => :submit do |sow, transition, test|
      sow.touch_date(:submitted_on)
      sow.touch_date(:rejected_on, nil)
      
      user = transition.args.first
      sow.submitted_by = user
      sow.approvals.destroy_all
      sow.save!
      
      Activity.record(user, 'submitted for review', sow, user)
      Activity.record(user, 'submitted for review', sow, sow.owner) if sow.owner != user
    end
    
    before_transition :on => :generate_award do |sow, transition|
      award = Award.from_sow(sow)
      sow.award = award
      user = transition.args.first
      sow.reviewed_by = user
      sow.touch_date(:accepted_on)
      Activity.record(user, 'awarded', sow, user)
      Activity.record(user, 'awarded', sow, sow.owner) if sow.owner != user
    end
    
    after_transition :on => :reject do |sow, transition|
      sow.touch_date(:rejected_on)
      user = transition.args.first
      sow.reviewed_by = user      
      Activity.record(user, 'rejected', sow, user)
      Activity.record(user, 'rejected', sow, sow.owner) if sow.owner != user
    end
    
    before_transition :on => :edit do |sow, transition|
      sow.approvals.destroy_all
      sow.submitted_on = nil
      sow.rejected_on = nil
      sow.save!
      
      user = transition.args.first
      unless sow.editing?
        Activity.record(user, 'edited', sow, user)
        Activity.record(user, 'edited', sow, sow.owner) if sow.owner != user
      end
    end
    
    before_transition :on => :groupleader_accept do |sow, transition|
      sow.approvals.where('name != ?', sow.award_group.name).destroy_all
    end
    before_transition :on => :administrator_accept do |sow, transition|
      sow.approvals.where('name = ? or name = ?', 'budget', sow.award_group.top.name).destroy_all
    end
    before_transition :on => :accept_budget do |sow, transition|
      sow.approvals.where('name = ?', sow.award_group.top.name).destroy_all
    end
    
    state :awarded do
      validates_presence_of :institute, :mau_id
    end
    
    state :submitted do
      validates_presence_of :institute, :mau_id      
    end
    
    event :edit do
      transition [:created, :editing, :submitted, :rejected] => :editing
    end
    
    event :submit do
      transition [:created, :editing, :groupleader_accepted, :administrator_accepted,:budget_accepted,:projectleader_accepted] => :submitted
    end
    
    event :groupleader_accept do
      transition [:submitted,:administrator_accepted,:budget_accepted,:projectleader_accepted] => :groupleader_accepted
    end
    
    event :administrator_accept do
      transition [:groupleader_accepted,:budget_accepted,:projectleader_accepted] => :administrator_accepted
    end
    
    event :accept_budget do
      transition [:administrator_accepted,:projectleader_accepted] => :budget_accepted
    end
    
    event :projectleader_accept do
      transition [:budget_accepted] => :projectleader_accepted
    end
    # 
    # event :review do
    #   transition [:submitted, :reviewing] => :reviewing
    # end
    
    event :generate_award do
      transition [:projectleader_accepted] => :awarded, :if => lambda { |sow| 
        sow.approvals.where(name: ['administrator', 'budget', sow.award_group.name, sow.award_group.top.name]).count >= 4
      }
    end
    
    event :reject do
      transition [:projectleader_accepted,:budget_accepted,:administrator_accepted,:groupleader_accepted] => :rejected
    end
  end

  attr_accessible :email, :first_name, :last_name, :other_strategic_objective, :period, :other_period, :telephone, 
    :project_title, :ua_number, :statement_of_work, :collaborators, :research_milestones_and_outcomes, 
    :accomplished_objectives, :budget_justification, :research_period_of_performance, :climate_glacier_dynamics,
    :ecosystem_variability, :resource_management, :strategic_objective_ids, :other_strategic_objectives_text,
    :discipline_ids, :disciplines, :award_group_id, :reviewed_by, :submitted_by, :review_notes, :mau_id, :institute,
    :starts_at, :ends_at

  validates_presence_of :award_group_id, :first_name, :last_name, :email, :project_title, :statement_of_work, :ua_number  
  
  scope :owner, lambda { |user| where(owner_id: user) }
  scope :unsubmitted, where(:state => [:created, :editing])
  scope :submitted, where(:state => [:submitted])
  scope :reviewing, where(:state => [:submitted,:projectleader_accepted,:budget_accepted,:administrator_accepted,:groupleader_accepted])
  scope :awarded, where(:state => :awarded)
  scope :rejected, where(:state => :rejected)
  scope :active, where(:state => [:created, :rejected])
  default_scope order('created_at DESC')
  
  def reviewable_by?(user)
    self.award_group.member_ids.include?(user.id) or self.award_group.top.member_ids.include?(user.id)
  end
  
  def ready_for_review?
    self.can_groupleader_accept? or self.can_administrator_accept? or self.can_accept_budget? or self.can_projectleader_accept? or self.can_generate_award?
  end
  
  def reviewing?
    self.submitted? or self.groupleader_accepted? or self.administrator_accepted? or self.budget_accepted? or self.projectleader_accepted?
  end
  
  def to_param
    "#{id}-#{self.project_title.parameterize}"
  end
  
  def period_days
    if self.period == 'other'
      self.other_period
    else
      self.period.to_i
    end
  end
  
  def touch_date(field, date = Time.zone.now)
    self.update_attribute(field, date)
  end
  
  def review_notes=(notes)
    prev_notes = read_attribute(:review_notes) || ''
    write_attribute(:review_notes, prev_notes + "\n\n" + notes)
  end
  
  def pi
    "#{self.first_name} #{self.last_name}"
  end
  
  def name
    self.project_title
  end
end

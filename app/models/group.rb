class Group < ActiveRecord::Base
  attr_accessible :acronym, :director_id, :fiscal_coordinator_id, :name
end

class Award < ActiveRecord::Base
  attr_accessible :description, :group_id, :pi_id, :slug, :title
end

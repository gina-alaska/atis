class AddTextfieldsToSows < ActiveRecord::Migration
  def change
    add_column :sows, :description, :text
    add_column :sows, :collaborators, :text
    add_column :sows, :research_milestones_and_outcomes, :text
    add_column :sows, :accomplished_objectives, :text
    add_column :sows, :budget_justification, :text
  end
end

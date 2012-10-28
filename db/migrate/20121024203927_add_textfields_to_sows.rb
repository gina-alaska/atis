class AddTextfieldsToSows < ActiveRecord::Migration
  def change
    add_column :sows, :statement_of_work, :text
    add_column :sows, :collaborators, :text
    add_column :sows, :research_milestones_and_outcomes, :text
    add_column :sows, :accomplished_objectives, :text
    add_column :sows, :budget_justification, :text
    add_column :sows, :research_period_of_performance, :string
    add_column :sows, :other_period, :integer
  end
end

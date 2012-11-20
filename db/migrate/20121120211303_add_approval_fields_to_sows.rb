class AddApprovalFieldsToSows < ActiveRecord::Migration
  def change
    add_column :sows, :pi_approval_id, :integer
    add_column :sows, :group_leader_approval_id, :integer
    add_column :sows, :rejection_reason, :text
  end
end

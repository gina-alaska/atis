class AddStatusToSows < ActiveRecord::Migration
  def change
    add_column :sows, :state, :string
    add_column :sows, :created_by, :integer
    add_column :sows, :submited_on, :datetime
    add_column :sows, :submited_by, :integer
    add_column :sows, :reviewed_by, :integer
    add_column :sows, :accepted_on, :datetime
    add_column :sows, :rejected_on, :datetime
  end
end

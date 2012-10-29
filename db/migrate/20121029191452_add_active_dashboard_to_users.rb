class AddActiveDashboardToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active_dashboard, :string, default: 'submitter'
  end
end

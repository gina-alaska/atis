class AddAwardGroupIdToSows < ActiveRecord::Migration
  def change
    add_column :sows, :group_id, :integer
  end
end

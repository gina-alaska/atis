class AddUserIdToSows < ActiveRecord::Migration
  def change
    add_column :sows, :user_id, :integer
  end
end

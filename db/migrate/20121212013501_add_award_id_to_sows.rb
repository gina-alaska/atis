class AddAwardIdToSows < ActiveRecord::Migration
  def change
    add_column :sows, :award_id, :integer
  end
end

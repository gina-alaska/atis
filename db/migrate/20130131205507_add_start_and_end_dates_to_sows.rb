class AddStartAndEndDatesToSows < ActiveRecord::Migration
  def change
    add_column :sows, :starts_at, :datetime
    add_column :sows, :ends_at, :datetime
  end
end

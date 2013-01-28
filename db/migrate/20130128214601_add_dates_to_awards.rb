class AddDatesToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :starts_at, :datetime
    add_column :awards, :ends_at, :datetime
  end
end

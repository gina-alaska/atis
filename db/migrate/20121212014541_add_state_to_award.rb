class AddStateToAward < ActiveRecord::Migration
  def change
    add_column :awards, :state, :string
  end
end

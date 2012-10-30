class AddOwnerToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :owner_id, :integer
  end
end

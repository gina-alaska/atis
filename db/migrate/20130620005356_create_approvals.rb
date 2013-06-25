class CreateApprovals < ActiveRecord::Migration
  def change
    create_table :approvals do |t|
      t.integer :user_id
      t.integer :sow_id
      t.string :name

      t.timestamps
    end
  end
end

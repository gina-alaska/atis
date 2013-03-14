class CreateStrategicObjectives < ActiveRecord::Migration
  def change
    create_table :strategic_objectives do |t|
      t.string :name
      t.integer :group_id

      t.timestamps
    end
  end
end

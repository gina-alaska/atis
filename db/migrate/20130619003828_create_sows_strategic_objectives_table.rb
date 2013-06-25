class CreateSowsStrategicObjectivesTable < ActiveRecord::Migration
  def change
    create_table :sows_strategic_objectives, id: false do |t|
      t.integer :sow_id
      t.integer :strategic_objective_id
    end
  end
end

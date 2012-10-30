class AddStrategicObjectivesToSows < ActiveRecord::Migration
  def change
    add_column :sows, :climate_glacier_dynamics, :boolean
    add_column :sows, :ecosystem_variability, :boolean
    add_column :sows, :resource_management, :boolean
    add_column :sows, :other_strategic_objectives, :boolean
    add_column :sows, :other_strategic_objectives_text, :string
  end
end

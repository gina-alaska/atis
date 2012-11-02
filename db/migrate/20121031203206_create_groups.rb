class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :acronym
      t.integer :fiscal_coordinator_id
      t.integer :director_id
      t.integer :parent_id
      t.integer :top_id

      t.timestamps
    end
  end
end

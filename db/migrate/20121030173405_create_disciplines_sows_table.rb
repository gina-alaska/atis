class CreateDisciplinesSowsTable < ActiveRecord::Migration
  def change
    create_table :disciplines_sows, id: false do |t|
      t.integer :sow_id
      t.integer :discipline_id
    end
  end
end

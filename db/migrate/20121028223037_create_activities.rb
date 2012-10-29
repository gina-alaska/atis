class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :subject_id
      t.string :subject_type
      t.integer :changed_item_id
      t.string :changed_item_type
      t.string :verb

      t.timestamps
    end
  end
end

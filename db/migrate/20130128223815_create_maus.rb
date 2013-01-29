class CreateMaus < ActiveRecord::Migration
  def change
    create_table :maus do |t|
      t.string :name

      t.timestamps
    end
  end
end

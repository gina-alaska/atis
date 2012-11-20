class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.string :slug
      t.string :title
      t.text :description
      t.integer :group_id
      t.integer :pi_id

      t.timestamps
    end
  end
end

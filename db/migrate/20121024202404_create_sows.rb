class CreateSows < ActiveRecord::Migration
  def change
    create_table :sows do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :telephone
      t.string :uaid
      t.integer :period
      t.string :title
      t.string :other_strategic_objective

      t.timestamps
    end
  end
end

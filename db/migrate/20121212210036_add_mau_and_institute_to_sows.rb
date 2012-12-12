class AddMauAndInstituteToSows < ActiveRecord::Migration
  def change
    add_column :sows, :mau_id, :integer
    add_column :sows, :institute, :string
  end
end

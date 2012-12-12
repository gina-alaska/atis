class AddMauAndInstituteToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :mau_id, :integer
    add_column :awards, :institute, :string
  end
end

class AddHostToServices < ActiveRecord::Migration
  def change
    add_column :services, :host, :string
  end
end

class AddBudgetAndAccountsToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :budget, :decimal, scale: 2, precision: 12
    add_column :awards, :account, :string
  end
end

class AddRolesToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :integer, default: 0
    add_column :users, :balance, :decimal, precision: 10, scale: 2, default: 0.00
  end
end

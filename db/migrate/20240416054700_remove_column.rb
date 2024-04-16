class RemoveColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :user_approval
    remove_column :stocks, :shares
    remove_column :transactions, :quantity

    add_column :stocks, :shares, :decimal, precision: 2, default: 0.00
  end
end
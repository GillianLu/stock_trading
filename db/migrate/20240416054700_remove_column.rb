class RemoveColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :user_approval if column_exists?(:users, :user_approval)
    remove_column :stocks, :shares if column_exists?(:stocks, :shares)
    remove_column :transactions, :quantity if column_exists?(:transactions, :quantity)

    unless column_exists?(:stocks, :shares)
      add_column :stocks, :shares, :decimal, precision: 2, default: 0.00
    end
  end
end

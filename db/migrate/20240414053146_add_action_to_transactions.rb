class AddActionToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :action, :string
  end
end

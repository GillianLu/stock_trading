class AddUserApproval < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :trader_approval, :boolean, default: :false
  end
end

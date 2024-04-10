class AddAdditionalInfoToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :last_name, :string, limit: 50
    add_column :users, :first_name, :string, limit: 50
    add_column :users, :address, :string
  end
end

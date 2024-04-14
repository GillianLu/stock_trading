class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stock_symbol
      t.integer :number_of_shares
      t.decimal :price_per_share
      t.decimal :total_amount

      t.timestamps
    end
  end
end

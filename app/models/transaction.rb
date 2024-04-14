class Transaction < ApplicationRecord
  belongs_to :user
  def self.buy(user, transaction_attributes)
    ActiveRecord::Base.transaction do
      transaction = user.transactions.build(transaction_attributes)
      transaction.total_amount = transaction_attributes[:number_of_shares] * transaction_attributes[:price_per_share]
      transaction.save!

      user.balance -= transaction.total_amount
      user.save!

      stock = user.stocks.find_or_initialize_by(symbol: transaction_attributes[:stock_symbol])
      stock.shares += transaction_attributes[:number_of_shares]
      stock.save!
    end
  end
end

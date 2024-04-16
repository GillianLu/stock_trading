class Transaction < ApplicationRecord
  belongs_to :user

  validates :action, presence: true
  validate :validate_transaction_amount

  def self.create_buy(user, attributes, total_cost)
    create_transaction(user, attributes, total_cost, 'buy')
  end

  def self.create_sell(user, attributes, total_cost)
    create_transaction(user, attributes, total_cost, 'sell')
  end

  private

  def self.create_transaction(user, attributes, total_cost, action)
    ActiveRecord::Base.transaction do
      transaction = user.transactions.create(attributes.merge(action: action, total_amount: total_cost))
      transaction.total_amount = total_cost
      transaction.action = action

      user.balance -= total_cost if action == 'buy'
      user.balance += total_cost if action == 'sell'
      user.save!

      stock = user.stocks.find_or_initialize_by(symbol: attributes[:stock_symbol])
      stock.shares += attributes[:number_of_shares].to_i if action == 'buy'
      stock.shares -= attributes[:number_of_shares].to_i if action == 'sell'
      stock.save!
    end
  end

  def validate_transaction_amount
    if action == 'buy' && user.balance < total_amount
      errors.add(:base, 'Not enough balance')
    elsif action == 'sell' && user.stocks.find_by(symbol: stock_symbol).shares < number_of_shares
      errors.add(:base, 'Not enough shares')
    end
  end
end
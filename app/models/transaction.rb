class Transaction < ApplicationRecord
  belongs_to :user

  validates :action, presence: true
  validate :validate_transaction_amount, if: -> { action == 'sell' }

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
    stock = user.stocks.find_by(symbol: stock_symbol)
    if stock.nil?
      errors.add(:base, 'Stock not found')
    elsif stock.shares < number_of_shares.to_i
      errors.add(:base, 'Not enough shares to sell')
    end
  end
end

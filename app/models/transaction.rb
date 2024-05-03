class Transaction < ApplicationRecord
  belongs_to :user

  validates :action, presence: true
  validate :validate_transaction_amount

  def self.create_buy(user, attributes, total_cost)
    transaction = user.transactions.create(attributes.merge(total_amount: total_cost, action: 'buy'))
    transaction.save ? transaction : nil
  end

  def self.create_sell(user, attributes, total_cost)
    user.transactions.create!(attributes.merge(total_amount: total_cost, action: 'sell'))
  end


  private

  def validate_transaction_amount
    if action == 'buy' && user.balance < total_amount
      errors.add(:base, 'Not enough balance')
    elsif action == 'sell'
      stock_item = user.stocks.find_by(symbol: stock_symbol)
      if stock_item.nil?
        errors.add(:base, 'Stock not found')
      elsif stock_item.shares < number_of_shares.to_i
        errors.add(:base, 'Not enough shares')
      end
    end
  end

end

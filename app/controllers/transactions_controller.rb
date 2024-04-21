class TransactionsController < ApplicationController
  load_and_authorize_resource

  def index
    @transactions = current_user.transactions
    @users_transactions = Transaction.all if current_user.admin?
  end

  def new
    @transaction = Transaction.new(
      stock_symbol: params[:stock_symbol],
      number_of_shares: params[:number_of_shares],
      price_per_share: params[:price_per_share]
    )
  end

  def buy
    create_transaction('buy', 'Stock purchased successfully and added to your portfolio!')
  end

  def sell
    create_transaction('sell', 'Stock sold successfully!')
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  private

  def create_transaction(action, success_message)
    total_cost = transaction_params[:number_of_shares].to_i * transaction_params[:price_per_share].to_d
    case action
    when 'buy'
      if current_user.balance >= total_cost
        handle_buy_transaction(total_cost, success_message)
      else
        redirect_to stocks_path, alert: 'Not enough balance'
      end
    when 'sell'
      stock_item = stock # Ensure we fetch the stock item
      if stock_item && stock_item.shares >= transaction_params[:number_of_shares].to_i
        handle_sell_transaction(success_message)
      elsif stock_item.nil?
        redirect_to stocks_path, alert: 'Stock not found'
      else
        redirect_to stocks_path, alert: 'Not enough shares'
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render :new, alert: e.message
  end

  def transaction_params
    params.require(:transaction).permit(:stock_symbol, :number_of_shares, :price_per_share)
  end

  def stock
    # Find the stock without initializing it if not found
    @stock ||= current_user.stocks.find_by(symbol: transaction_params[:stock_symbol])
  end

  def handle_buy_transaction(total_cost, success_message)
    # Assuming Transaction.create_buy creates a transaction record
    Transaction.create_buy(current_user, transaction_params, total_cost)
    redirect_to stocks_path, notice: success_message
  end

  def handle_sell_transaction(success_message)
    sold_shares = transaction_params[:number_of_shares].to_i
    sell_price_per_share = transaction_params[:price_per_share].to_d
    total_revenue = sold_shares * sell_price_per_share

    ActiveRecord::Base.transaction do
      new_share_count = stock.shares - sold_shares

      if new_share_count.positive?
        stock.update(shares: new_share_count)
      else
        stock.destroy
      end

      current_user.update(balance: current_user.balance + total_revenue)

      Transaction.create_sell(current_user, transaction_params, total_revenue)

      redirect_to stocks_path, notice: success_message
    rescue ActiveRecord::RecordInvalid => e
      redirect_to stocks_path, alert: e.message
    end
  end

end

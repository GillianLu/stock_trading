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
    if action == 'buy' && current_user.balance >= total_cost || action == 'sell' && stock.shares >= transaction_params[:number_of_shares].to_i
      Transaction.send("create_#{action}", current_user, transaction_params, total_cost)
      redirect_to stocks_path, notice: success_message
    else
      redirect_to stocks_path, alert: action == 'buy' ? 'Not enough balance' : 'Not enough shares'
    end
  rescue ActiveRecord::RecordInvalid => e
    render :new, alert: e.message
  end

  def transaction_params
    params.require(:transaction).permit(:stock_symbol, :number_of_shares, :price_per_share)
  end

  def stock
    @stock = current_user.stocks.find_or_initialize_by(symbol: transaction_params[:stock_symbol])
  end

  def current_ability
    @current_ability ||= UserAbility.new(current_user)
  end
end
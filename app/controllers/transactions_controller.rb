class TransactionsController < ApplicationController
  def new
    @transaction = Transaction.new(
      stock_symbol: params[:stock_symbol],
      number_of_shares: params[:number_of_shares],
      price_per_share: params[:price_per_share]
    )
  end

  def create
    stock = current_user.stocks.find_or_initialize_by(symbol: transaction_params[:stock_symbol])
    shares = transaction_params[:number_of_shares].to_i
    price = transaction_params[:price_per_share].to_d
    total_cost = shares * price

    if current_user.balance >= total_cost
      ActiveRecord::Base.transaction do
        stock.shares = stock.shares.to_i + shares
        stock.latest_price = price
        stock.save!
        current_user.update!(balance: current_user.balance - total_cost)
        current_user.transactions.create!(transaction_params.merge(total_amount: total_cost))
        redirect_to stocks_path, notice: 'Stock purchased successfully and added to your portfolio'
      end
    else
      redirect_to new_transaction_path, alert: 'Not enough balance'
    end
  rescue ActiveRecord::RecordInvalid => e
    render :new, alert: e.message
  end

  def show
    @transaction = Transaction.find(params[:id])
  end

  private

  def transaction_params
    params.require(:transaction).permit(:stock_symbol, :number_of_shares, :price_per_share)
  end

  def fetch_stock_details(symbol)
    quote = @client.quote(symbol)
    {
      symbol: symbol,
      name: quote.company_name,
      latest_price: quote.latest_price,
      price_24h_ago: quote.previous_close
    }
  end


end

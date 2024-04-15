class StocksController < ApplicationController
  #before_action :set_client, only: [:index, :show]
  before_action :set_stock, only: :show

  def index
    @stocks = current_user.stocks
    @stocks_for_trading = fetch_all_stocks_for_trading(10)
    if @stocks.any?
      #show current stock plus stocks that is available for trading
    else
      @no_stocks_message = "You don't have any stocks yet."
    end
  end


  def show
    @stock = fetch_stock_details(params[:id])
  end

  private

  def set_stock
     @stock = params[:id]
  end

  def fetch_all_stocks_for_trading(limit = 10)
    all_symbols = @client.ref_data_symbols.map(&:symbol)

    user_owned_symbols = current_user.stocks.pluck(:symbol)
    remaining_symbols = all_symbols - user_owned_symbols

    remaining_symbols.first(limit).map do |symbol|
      quote = @client.quote(symbol)
      {
        symbol: symbol,
        name: quote.company_name,
        latest_price: quote.latest_price,
        price_24h_ago: quote.previous_close
      }
    end
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

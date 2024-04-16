class StocksController < ApplicationController
  before_action :set_stock, only: :show

  def index
    stocks = current_user.stocks
    @stocks_for_trading = fetch_all_stocks_for_trading(10)
    if stocks.any?
      #show current stock plus stocks that is available for trading
      @stocks = fetch_stocks_details(stocks)
    else
      @no_stocks_message = "You don't have any stocks yet."
    end
  end


  def show
  end

  private

  def set_stock
    @stock = fetch_stock_details(params[:symbol])
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

    if current_user.stocks.exists?(symbol: symbol)
      stock = current_user.stocks.find_by(symbol: symbol)
      stock.update(latest_price: quote.latest_price)
    end

    user_stock = current_user.stocks.find_by(symbol: stock.symbol)

    {
      symbol: symbol, 
      name: quote.company_name,
      latest_price: quote.latest_price,
      price_24h_ago: quote.previous_close,
      shares: user_stock ? user_stock.shares : nil  # Check if user_stock exists before accessing its attributes
    }
  end

  def fetch_stocks_details(stocks)
    
    stocks.map do |stock| 
      quote = @client.quote(stock.symbol)
      
      if current_user.stocks.exists?(symbol: stock.symbol)
        user_stock = current_user.stocks.find_by(symbol: stock.symbol)
        user_stock.update(latest_price: quote.latest_price)
      end
  
      # Find the specific stock instance to access its attributes
      user_stock = current_user.stocks.find_by(symbol: stock.symbol)
      
      {
        symbol: stock.symbol, 
        name: quote.company_name,
        latest_price: quote.latest_price,
        price_24h_ago: quote.previous_close,
        shares: user_stock ? user_stock.shares : nil  # Check if user_stock exists before accessing its attributes
      }
    end
  end

  def current_ability
    @current_ability ||= UserAbility.new(current_user)
  end
end

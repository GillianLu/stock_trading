class StocksController < ApplicationController
  before_action :set_stock, only: :show

  def index
    if current_user.admin?
      redirect_to users_path
    else
      @page = params[:page].to_i > 0 ? params[:page].to_i : 1
      @stocks_for_trading = fetch_all_stocks_for_trading(@page, 5)
      @stocks = current_user.stocks # This needs to be an instance variable

      if @stocks.any?
        @stocks = fetch_stocks_details(@stocks)
      else
        @no_stocks_message = "You don't have any stocks yet."
      end
    end
  end


  def show
    unless @stock
      redirect_to stocks_path, alert: "Stock not found."
      return
    end
  end

  private

  def set_stock
    symbol = params[:symbol]
    @stock = current_user.stocks.find_by(symbol: symbol)

    unless @stock
      begin
        quote = @client.quote(symbol)
        @stock = {
          symbol: symbol,
          name: quote.company_name,
          latest_price: quote.latest_price,
          price_24h_ago: quote.previous_close,
          change: quote.change,
          change_percent: quote.change_percent,
          change_percent_s: quote.change_percent_s,
          shares: 0
        }
      rescue StandardError => e
        Rails.logger.error "Failed to fetch stock details: #{e.message}"
        redirect_to stocks_path, alert: "Stock details not available."
        return
      end
    end
  end


  def fetch_all_stocks_for_trading(page = 1, limit = 5)
    all_symbols = @client.ref_data_symbols.map(&:symbol)
    user_owned_stocks = current_user.stocks.each_with_object({}) do |stock, hash|
      hash[stock.symbol] = stock.shares
    end

    # Calculate the pagination
    offset = (page.to_i - 1) * limit
    total_stocks = all_symbols.count
    total_pages = (total_stocks.to_f / limit).ceil

    # You can also set @has_next_page as an instance variable to use in your view
    @has_next_page = page.to_i < total_pages

    # Paginate the stocks
    paginated_symbols = all_symbols[offset, limit]

    paginated_symbols.map do |symbol|
      quote = @client.quote(symbol)
      {
        symbol: symbol,
        name: quote.company_name,
        latest_price: quote.latest_price,
        price_24h_ago: quote.previous_close,
        change: quote.change,
        change_percent: quote.change_percent,
        change_percent_s: quote.change_percent_s,
        user_shares: user_owned_stocks[symbol] || 0
      }
    end
  rescue StandardError => e
    Rails.logger.error "Failed to fetch stock data: #{e.message}"
    []
  end




  def fetch_stock_details(symbol)
    begin
      quote = @client.quote(symbol)
    rescue StandardError => e
      Rails.logger.error "Failed to retrieve quote for symbol: #{symbol}, Error: #{e.message}"
      return nil
    end

    stock = current_user.stocks.find_by(symbol: symbol)
    stock.update(latest_price: quote.latest_price) if stock

    return nil unless stock

    {
      symbol: stock.symbol,
      name: quote.company_name,
      latest_price: quote.latest_price,
      price_24h_ago: quote.previous_close,
      change: quote.change,
      change_percent: quote.change_percent,
      change_percent_s: quote.change_percent_s,
      shares: stock.shares
    }
  end

  def fetch_stocks_details(stocks)
    stocks.map do |stock|
      quote = @client.quote(stock.symbol)

      if current_user.stocks.exists?(symbol: stock.symbol)
        user_stock = current_user.stocks.find_by(symbol: stock.symbol)
        user_stock.update(latest_price: quote.latest_price)
      end

      user_stock = current_user.stocks.find_by(symbol: stock.symbol)

      {
        symbol: stock.symbol,
        name: quote.company_name,
        latest_price: quote.latest_price,
        price_24h_ago: quote.previous_close,
        change: quote.change,
        change_percent: quote.change_percent,
        change_percent_s: quote.change_percent_s,
        shares: user_stock ? user_stock.shares : nil
      }
    end
  end

end

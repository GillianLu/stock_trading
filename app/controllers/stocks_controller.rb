class StocksController < ApplicationController
  before_action :set_stock, only: :show

  def index
    if current_user.admin?
      redirect_to users_path
    else
      @page = params[:page].to_i > 0 ? params[:page].to_i : 1
      @search = params[:search]
      @stocks_for_trading = fetch_all_stocks_for_trading(@page, 4, @search)

      # Implement manual pagination for user's stocks
      @user_stocks_all = current_user.stocks
      @stocks_per_page = 3
      @total_user_stocks = @user_stocks_all.count
      @total_user_pages = (@total_user_stocks.to_f / @stocks_per_page).ceil
      @user_stocks = @user_stocks_all.offset((@page - 1) * @stocks_per_page).limit(@stocks_per_page)

      if @user_stocks.any?
        @stocks = fetch_stocks_details(@user_stocks)
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


def fetch_all_stocks_for_trading(page = 1, limit = 4, search = nil)
    all_symbols = @client.ref_data_symbols.map(&:symbol)
    user_owned_stocks = current_user.stocks.each_with_object({}) do |stock, hash|
      hash[stock.symbol] = stock.shares
    end

    filtered_symbols = search ? all_symbols.select { |s| s.downcase.include?(search.downcase) } : all_symbols

    offset = (page.to_i - 1) * limit
    total_stocks = filtered_symbols.count
    total_pages = (total_stocks.to_f / limit).ceil

    @has_next_page = page.to_i < total_pages

    paginated_symbols = filtered_symbols[offset, limit]

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

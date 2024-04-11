class StocksController < ApplicationController
  before_action :set_client, only: [:index, :show]
  before_action :set_stock, only: :show

  def index
    if current_user.stocks.any?
      @stocks = fetch_user_stocks
    else
      @no_stocks_message = "You don't have any stocks yet."
      @stocks_for_trading = fetch_all_stocks_for_trading(10)
    end
  end

  def show
    @stock = fetch_stock_details(params[:id])
  end

  private

  def set_client
    @client = IEX::Api::Client.new(
      publishable_token: 'pk_5e55ef8506ea4a679f622241863e6de4',
      secret_token: 'sk_d12bd19300c243b995b9398dbfbaf951',
      endpoint: 'https://cloud.iexapis.com/v1'
    )
  end

  def set_stock
     @stock = params[:id]
  end

  def fetch_all_stocks_for_trading(limit = 10)
    client = IEX::Api::Client.new
    all_symbols = client.ref_data_symbols.map(&:symbol)

    user_owned_symbols = current_user.stocks.pluck(:symbol)
    remaining_symbols = all_symbols - user_owned_symbols

    remaining_symbols.first(limit).map do |symbol|
      quote = client.quote(symbol)
      {
        symbol: symbol,
        name: quote.company_name,
        latest_price: quote.latest_price,
        price_24h_ago: quote.previous_close
      }
    end
  end

    def fetch_stock_details(symbol)
    client = IEX::Api::Client.new
    quote = client.quote(symbol)
    {
      symbol: symbol,
      name: quote.company_name,
      latest_price: quote.latest_price,
      price_24h_ago: quote.previous_close
    }
  end

end

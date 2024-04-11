# app/services/iex_client.rb
require 'net/http'
require 'uri'

class IexClient
  def self.get_stock_data(symbol)
    api_key = Rails.application.credentials.dig(:iex_cloud, :api_key)
    url = URI("https://cloud.iexapis.com/stable/stock/#{symbol}/quote?token=#{api_key}")

    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body).slice('symbol', 'latestPrice', 'companyName')
    else
      { symbol: symbol, error: "Data unavailable" }
    end
  rescue => e
    Rails.logger.error "Exception occurred: #{e.message}"
    { symbol: symbol, error: e.message }
  end
end

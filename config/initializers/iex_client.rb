require 'iex-ruby-client'

IEX::Api.configure do |config|
  config.publishable_token = ENV['IEX_PUBLISHABLE_TOKEN']; #'pk_cb2b3e6637b148bf9aec2d9fdba8ce2a'
  config.secret_token = ENV['IEX_SECRET_TOKEN']; #'sk_c3a01fb3f9904f908677106043b47a01'
  config.endpoint = 'https://cloud.iexapis.com/v1'
end

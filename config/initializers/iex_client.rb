require 'iex-ruby-client'

IEX::Api.configure do |config|
  config.publishable_token = 'pk_5e55ef8506ea4a679f622241863e6de4'
  config.secret_token = 'sk_d12bd19300c243b995b9398dbfbaf951'
  config.endpoint = 'https://cloud.iexapis.com/v1'
end

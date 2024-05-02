require 'iex-ruby-client'

IEX::Api.configure do |config|
  config.publishable_token = 'pk_061daf2b8f26493f8db42a5a66aaca38'; #'pk_cb2b3e6637b148bf9aec2d9fdba8ce2a' #gill pk_5e55ef8506ea4a679f622241863e6de4
  config.secret_token = 'sk_f25d582ed07247e39937efa1a25d990c'; #'sk_c3a01fb3f9904f908677106043b47a01' #gill sk_d12bd19300c243b995b9398dbfbaf951
  config.endpoint = 'https://cloud.iexapis.com/v1'
end

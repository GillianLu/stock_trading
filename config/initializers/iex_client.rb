require 'iex-ruby-client'

IEX::Api.configure do |config|
  config.publishable_token = 'pk_2bd1d274acf24684926116c764648c8a'; #'pk_cb2b3e6637b148bf9aec2d9fdba8ce2a' #gill pk_5e55ef8506ea4a679f622241863e6de4
  config.secret_token = 'sk_306848ce25a748d2b61907bae89ae907'; #'sk_c3a01fb3f9904f908677106043b47a01' #gill sk_d12bd19300c243b995b9398dbfbaf951
  config.endpoint = 'https://cloud.iexapis.com/v1'
end

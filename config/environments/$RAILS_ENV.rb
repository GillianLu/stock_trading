Rails.application.configure do

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address:         'smtp.gmail.com',
    port:            587,
    domain:          'stock-trading-8dja.onrender.com', 
    user_name:       'acostayuukichi@gmail.com',
    password:        'tanginamo071303', 
    authentication:  'plain',
    enable_starttls: true,
    open_timeout:    5,
    read_timeout:    5
  }

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'https://stock-trading-8dja.onrender.com', protocol: 'https' }
  config.action_mailer.default_options = { from: 'no-reply@stock-trading.com' }

end

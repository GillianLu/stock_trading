require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.assets.compile = false
  config.active_storage.service = :local
  config.force_ssl = true

  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address:         'smtp.gmail.com',
    port:            587,
    domain:          'stock-trading-8dja.onrender.com', 
    user_name:       'acostayuukichi@gmail.com',
    password:        'mcts mnic mgbq ipbw', 
    authentication:  'plain',
    enable_starttls: true,
    open_timeout:    5,
    read_timeout:    5
  }

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  
  config.action_mailer.default_url_options = { host: 'stock-trading-8dja.onrender.com' }
  config.action_mailer.default_options = { from: 'acostayuukichi@gmail.com' }

end

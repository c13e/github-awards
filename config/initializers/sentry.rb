Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environments = %w[ production development ]
end

require 'datadog/statsd'

Datadog.configure do |c|
  c.use :rails, service_name: 'rails-app'
  c.use :sidekiq
end

$statsd = Datadog::Statsd.new('localhost', 8125)

# Increment a counter.
$statsd.increment('system.startup')

require 'datadog/statsd'
require 'ddtrace'

Datadog.configure do |c|
  # To enable runtime metrics collection, set `true`. Defaults to `false`
  # You can also set DD_RUNTIME_METRICS_ENABLED=true to configure this.
  c.runtime_metrics_enabled = true

  c.use :rails, service_name: 'rails-app'
  # c.use :sidekiq, service_name: 'sidekiq-server'
  c.use :redis, service_name: 'redis-server'
end

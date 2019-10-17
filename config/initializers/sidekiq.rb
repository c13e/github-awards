require 'ddtrace/contrib/sidekiq/server_tracer'

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add(Sidekiq::ServerTracer)
    chain.add Sidekiq::Throttler, storage: :redis
  end
end

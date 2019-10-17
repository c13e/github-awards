Datadog.configure do |c|
  c.use :rails, service_name: 'rails-app'
  c.use :sidekiq
  c.use :rake
end

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
ENV['NEWRELIC_ENABLE'] = 'false'
require File.expand_path('../config/application', __FILE__)
require 'ddtrace'

Datadog.configure do |c|
  c.use :rake
end

Rails.application.load_tasks

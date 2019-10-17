######################################################
## Background Context
# Based on: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server
######################################################

## Heroku Dynos
# Dynos are Heroku's fancy term for a virtual computer.

## Workers
# Puma can be configured to make a Dyno run multiple computing
# processes in the Dyno. In Puma-speak, these different OS processes are called
# Workers. Workers allow a Rails app to support multiple concurrent web
# requests.

# Workers use more RAM as the entire codebase is loaded into each worker.

# NOTE: It is important not to confuse Puma workers with Heroku workers
# or Sidekiq workers. They are all slightly different concepts.

## Threads
# Each Puma Worker has the ability to hold a virtual pool of Threads.
# This will provide further concurrency for each Worker, at the
# expense of code needing to be thread safe.

# Threads place the burden on CPU resources.

######################################################

# Each Heroku dyno will start the number of workers as defined here:
workers Integer(ENV['RAILS_WEB_CONCURRENCY'] || 1)

# Puma will instantiate threads per worker, based on:
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)

threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'
worker_timeout ENV['PUMA_WORKER_TIMEOUT'] || 60

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

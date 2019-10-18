class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  caches_action :about
  before_action :set_raven_context

  def welcome
  end

  def about
  end

  def stress
    Rails.logger.info "[STRESS] Starting expensive db query"
    match = params[:search] || 'e'

    repos =
      Repository
        .joins(:user)
        .includes(user: {repositories: { user: :authentication_providers }})
        .where("repositories.name || ' ' || users.login ILIKE ?", "%#{match}%")
        .order(:github_id)

    Rails.logger.info "[STRESS] Done with expensive db query"

    Rails.logger.info "[STRESS] Starting memory-consuming operation"
    really_big_collection = []
    sample_size = params[:sample_size]&.to_i || 500

    repos.each do |repo|
      really_big_collection << Repository.all.sample(sample_size)
    end

    size = really_big_collection.size

    Rails.logger.info "[STRESS] Done with memory-consuming operation"

    flash[:alert] = "Don't be cruel!"
    return redirect_to '/'
  end

  def exception
    Rails.logger.info "[ERROR] About to throw an exception!!"
    raise "Runtime exception baby!!!"
  end

  def not_found
    raise ActiveRecord::RecordNotFound.new('Not Found')
  end

  private

  def set_raven_context
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end

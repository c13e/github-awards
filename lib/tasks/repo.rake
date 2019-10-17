namespace :repo do
  desc "Crawl github API for repositories"
  task crawl: :environment do
    Rails.logger.info "Start crawling"
    Tasks::RepositoryImporter.new.crawl_github_repos
  end

  desc "Import repos from github archive"
  task import: :environment do
    RepositoryStreamWorker.new.perform(time: 1.day.ago)
  end

  desc "Update all repos and their users"
  task update_repos: :environment do
    Repository.pluck(:name).each do |repo_name|
      login = repo_name.split("/")[0]
      user = User.where(login: login.downcase).first
      if user.nil?
        Rails.logger.info("Unable to find user #{login}")
      else
        Rails.logger.info("Updating user #{login}")
        UserUpdateWorker.perform_in(rand(0..60*60).seconds, login, true)
        repo = repo_name.split("/")[1]
        Rails.logger.info("Updating repo #{repo}")
        RepositoryUpdateWorker.perform_in(rand(0..60*60).seconds, user.id, repo)
      end
    end
  end
end

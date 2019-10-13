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
end

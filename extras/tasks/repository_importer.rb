class Tasks::RepositoryImporter
  def crawl_github_repos
    client = Models::GithubClient.new(ENV["GITHUB_TOKEN"])
    client.on_found_object = lambda do |repo, user|
      Repository.create(github_id: repo["id"],
        name: repo["name"],
        user: user,
        forked: repo["fork"] || false)
    end

    client.on_too_many_requests = lambda do |error|
      Rails.logger.error error
      sleep 10
      return nil
    end

    client.fetch_repositories(:repositories)
  end
end

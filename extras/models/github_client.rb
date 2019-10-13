class Models::GithubClient
  attr_accessor :max_list_size
  attr_accessor :on_found_object, :on_error, :on_too_many_requests

  def initialize(token=nil)
    @client = Octokit::Client.new(access_token: token)
    @max_list_size = 1000
    @current_result_size = 0
    @current_page = 1
  end

  def fetch_users(method, query)
    loop do
      args = [query, { sort: 'joined', order: 'asc', per_page: 100, page: @current_page }]
      Rails.logger.info "querying for page: #{@current_page}"
      results = api_call(method, args)
      next if results.nil?

      results.items.each do |object|
        on_found_object.call(object)
      end

      @current_result_size += results.items.size
      Rails.logger.info "Current total at #{@current_result_size} users"
      break if @current_result_size >= @max_list_size
      @current_page += 1
    end
  end

  def fetch_repositories(method)
    User.find_each do |user|
      results = api_call(method, [user.login])
      next if results.nil?

      Rails.logger.info "found #{results.size} objects"

      results.each do |object|
        on_found_object.call(object, user)
      end
    end
  end

  def get(method, params)
    api_call(method, params)
  end

  private

  def api_call(method, args)
    begin
      @client.send(method, *args)
    rescue Octokit::TooManyRequests => e
      on_too_many_requests.call(e) if on_too_many_requests
    rescue StandardError => e
      on_error.call(e) if on_error
    end
  end
end

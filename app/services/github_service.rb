class GithubService


  def self.create_webhook access_token, repo_name
    client = Octokit::Client.new access_token: access_token
    webhook = { errors: {} }
    begin
      resp = client.create_hook(
        "#{client.user[:login]}/#{repo_name}",
        'web',
        {
          :url => 'http://ensemblejs.com/notifications',
          :content_type => 'json'
        },
        {
          :events => ['push'],
          :active => true
        }
      ).to_attrs

      webhook.merge!(resp.slice(:id))
    rescue Octokit::NotFound => e
      webhook[:errors][:not_found_404] = "Something about a 404, or even a proper translation dealy"
    rescue Octokit::UnprocessableEntity => e
      webhook[:errors][:unprocessable_entity_422] = "Something about a 422, or even a proper translation dealy"
    end
    webhook
  end



  def self.user_details access_token
    client = Octokit::Client.new access_token: access_token
    github_user = client.user
    { login: github_user[:login], 
      avatar_url: github_user[:avatar_url] }
  end

end
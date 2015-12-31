class GithubService


  def self.create_webhook user_name, access_token, repo_name
    client = Octokit::Client.new access_token: access_token
    webhook = { errors: {} }
    begin
      resp = client.create_hook(
        "#{user_name}/#{repo_name}",
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

      webhook.merge!(resp.slice(:url, :test_url, :ping_url, :active))
    rescue Octokit::NotFound => e
      webhook[:errors][:not_found_404] = "Something about a 404, or even a proper translation dealy"
    rescue Octokit::UnprocessableEntity => e
      webhook[:errors][:unprocessable_entity_422] = "Something about a 422, or even a proper translation dealy"
    end
    webhook
 end

end
class Webhook < ActiveRecord::Base
  
  belongs_to :user

  def self.create_for_user user, repo_name
    return false if user.webhooks.exists?(repo_name: repo_name)
    create! do |hook|
      client = Octokit::Client.new access_token: user.token
      resp = client.create_hook(
        "#{user.login}/#{repo_name}",
        'web',
        {
          :url => 'http://ensemblejs.com/notifications',
          :content_type => 'json'
        },
        {
          :events => ['push'],
          :active => true
        }
      )
      hook.user = user
      hook.repo_name = repo_name
      hook.url = resp[:url]
      hook.test_url = resp[:test_url]
      hook.ping_url = resp[:ping_url]
      hook.active = resp[:active]
    end
  end
end
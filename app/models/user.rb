require 'pry'

class User < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.token = auth['credentials']['token']
      client = Octokit::Client.new access_token: self.token
      user.login = client.user[:login]
      user.avatar_url = client.user[:avatar_url]
    end
  end



  def create_hook repo
    client = Octokit::Client.new access_token: self.token
    binding.pry
    hook = client.create_hook(
      repo,
      'web',
      {
        :url => 'http://something.com/webhook',
        :content_type => 'json'
      },
      {
        :events => ['push', 'pull_request'],
        :active => true
      }
    )
  end
end

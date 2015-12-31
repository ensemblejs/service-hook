require 'pry'


class User < ActiveRecord::Base
  has_many :webhooks

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.token = auth['credentials']['token']
      client = Octokit::Client.new access_token: user.token
      github_user = client.user
      user.login = github_user[:login]
      user.avatar_url = github_user[:avatar_url]
    end
  end

  def create_game repo_name
    Game.create_for_user self.login
  end

  private

  def github_identifier repo_name
    "#{self.login}/#{repo_name}"
  end

end

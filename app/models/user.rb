require 'pry'


class User < ActiveRecord::Base
  has_many :webhooks

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.token = auth['credentials']['token']
      details = GithubService.user_details user.token
      user.login = details[:login]
      user.avatar_url = details[:avatar_url]
    end
  end


  def create_webhook repo_name
    webhook = GithubService.create_webhook(token, repo_name)
    repo = Repository.find_or_create_by(user_id: id, name: repo_name)
    Webhook.create!(  id: webhook[:id],
                      user: self, 
                      repository: repo)
  end


  def create_game repo_name
    Game.create_for_user self.login
  end

  private

  def github_identifier repo_name
    "#{self.login}/#{repo_name}"
  end

end

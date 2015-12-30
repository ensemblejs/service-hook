class WebhooksController < ApplicationController

  def create
    
    @repo = "#{current_user.login}/#{repo_name}"
    if Webhook.create_for_user(current_user, repo_name)
      render "create_success"
    else
      render "terrible_failure"
    end
  end

  def select_repo
    client = Octokit::Client.new access_token: current_user.token
    @repos = client.repositories.map(&:name).sort
  end

  private

  def repo_name
    params.require(:repo)
  end
end
class WebhooksController < ApplicationController

  def create
    @repo = "#{current_user.login}/#{repo_name_param}"
    if Webhook.create_for_user(current_user, repo_name_param)
      render "create_success"
    else
      render "terrible_failure"
    end
  end

  def list_repos
    client = Octokit::Client.new access_token: current_user.token
    @repos = client.repositories.map(&:name).sort
  end



  private

  def repo_name_param
    params.require(:repo)
  end
end
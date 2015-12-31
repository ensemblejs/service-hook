class WebhooksController < ApplicationController

  def create
    @repo = "#{current_user.login}/#{repo_name_param}"
    # resp = GithubService.create_webhook(current_user.token, repo_name_param)
    if resp = current_user.create_webhook
      render "create_success"
    else
      @errors = resp[:errors]
      render "terrible_failure"
    end
  end


  def select_repo
    client = Octokit::Client.new access_token: current_user.token
    @repos = client.repositories.map(&:name).sort
  end

  

  private

  def repo_name_param
    params.require(:repo)
  end
end
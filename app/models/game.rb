class Game < ActiveRecord::Base
  belongs_to :user

  def create_for_user user_name, repo_name
    game = SwarmService.create_game user_name, repo_name
    binding.pry
  end
end

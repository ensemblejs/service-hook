class GamesController < ApplicationController
  def create
    Game.create_for_user(games_params[:user], games_params[:repo])
  end

  private

  def games_params
    params.require(:user, :repo)
  end
end
class Published::LosController < ApplicationController

  def show
    if current_user.admin?
      @lo = Lo.includes(:introductions, :exercises).find(params[:id])
    else
      if params[:team_id]
        team = current_user.teams.find(params[:team_id])
        @lo = team.los.find(params[:id]) if team
      else
        @lo = current_user.los.find(params[:id])
      end
    end
  end

  #def show
  #  @lo = Lo.includes(:introductions, :exercises).find(params[:id])
  #end
end

class ReportsController < ApplicationController
  respond_to :json
  before_filter :load_teams, except: :current_user_los

  def current_user_teams_los
    @teams = current_user.teams
  end

  def current_user_created_teams
  end

  def los_from_team
    @los = @teams.find(params[:team_id]).los
  end

  def learners
    @team = @teams.find(params[:team_id])
    @lo = @team.los.find(params[:lo_id])
    @learners = @team.users.asc(:name)
  end

  def timeline
    @team = @teams.find(params[:team_id])
    @lo = @team.los.find(params[:lo_id])
    @user = @team.users.find(params[:user_id])

    @answers = @user.answers.every.
                     where(team_id: params[:team_id], 
                           :"lo.from_id" => Moped::BSON::ObjectId.from_string(params[:lo_id])).
                     asc(:created_at)
  end

  def my_timeline
    @team = current_user.teams.find(params[:team_id])
    @lo = @team.los.find(params[:lo_id])
    @user = current_user

    @answers = @user.answers.every.
                     where(team_id: params[:team_id], 
                           :"lo.from_id" => Moped::BSON::ObjectId.from_string(params[:lo_id])).
                     asc(:created_at)
  end
private
  def load_teams
    @teams = current_user.admin? ? Team.all : current_user.owner_teams
  end
end

class TeamsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!
  before_filter :teams, except: :enrolled

  def index
    @teams = Team.search(params[:search]).page(params[:page]).per(10)
  end

  def enrolled
    @teams = current_user.teams.includes(:users, :los)
  end

  def created
    @teams = @owner_teams.includes(:users).desc(:created_at)
  end

  # My teams
  # Teams that current user created or enrolled
  def my_teams
    @teams = Team.or({owner_id: current_user.id} , {user_ids: current_user.id})
  end

  def learners
    @learners = []
    if params[:team_id] && current_user.admin?
      @learners = Team.includes(:users).find(params[:team_id]).users
    elsif params[:team_id]
      @learners = Team.includes(:users).where(owner_id: current_user.id, id: params[:team_id]).
                       first.users
    end
    @learners
  end

  def enroll
    @team = Team.available.find(params[:id])
    if @team.enroll(current_user, params[:code])
      respond_with(@team)
    else
      respond_with(@team, status: 422)
    end
  end

  def show
    #@team = @owner_teams.find(params[:id])
    @team = Team.find(params[:id])
  end

  def create
    @team = Team.new(params[:team])
    @team.owner_id = current_user.id

    if @team.save
      respond_with(@team)
    else
      respond_with(@team, status: 422)
    end
  end

  def update
    @team = @owner_teams.find(params[:id])

    if @team.update_attributes(params[:team])
      respond_with(@team)
    else
      respond_with(@team, status: 422)
    end
  end

  def destroy
    @team = @owner_teams.find(params[:id])
    @team.destroy
    respond_with(@team)
  end

  # find los of teams
  # use in visual search
  def los
    @los = Team.find(params[:team_id]).los
  end


private
  def teams
    if current_user.admin?
      @owner_teams = Team.all
    else
      @owner_teams = current_user.owner_teams
    end
  end

end

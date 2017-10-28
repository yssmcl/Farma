class LosController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  def index
    if current_user.admin?
      @los = Lo.all.includes(:user).desc(:created_at)
    else
      @los = current_user.los.order_by(:created_at => :desc)
    end
  end

  # Shared Los
  # Los marked as can_share equal true
  def shared
    @los = Lo.search(params[:search]).page(params[:page]).per(15)
  end

  def show
    if current_user.admin?
      @lo = Lo.find(params[:id])
      respond_with @lo
    else
      respond_with current_user.los.find(params[:id])
    end
  end

  def create
    @lo = current_user.los.create(params[:lo])
    respond_with @lo
  end

  def update
    if current_user.admin?
      @lo = Lo.find(params[:id])
    else
      @lo = current_user.los.find(params[:id])
    end

    if  @lo.update_attributes(params[:lo])
      respond_with(@lo)
    else
      respond_with(@lo, status: 402)
    end
  end

  def destroy
    if current_user.admin?
      respond_with current_user.los.find(params[:id]).destroy
    else
      respond_with Lo.find(params[:id]).destroy
    end
  end

  # Los Enrolled
  def my_los
    if params[:team_id]
      @los = Team.find(params[:team_id]).los
    else
      teams_lo = []
      Team.where(owner_id: current_user.id).each do |team|
        teams_lo = teams_lo | team.los
      end
      @los = current_user.los | teams_lo
    end
  end

  def exercises
    @exercises = Lo.find(params[:id]).exercises
  end

  # def introductions
  #   @introductions = Lo.find(params[:id]).introductions
  # end
end

class Published::LosController < ApplicationController

  #def show
  #  if current_user.admin?
  #    @lo = Lo.includes(:introductions, :exercises).find(params[:id])
  #  else
  #    if params[:team_id]
  #      team = current_user.teams.find(params[:team_id])
  #      @lo = team.los.find(params[:id]) if team
  #    else
  #      @lo = current_user.los.find(params[:id])
  #    end
  #  end
  #end

  # Its use by, preview, publihesd and shared view
  def show
    if params[:learner_id]
      @user = User.find(params[:learner_id])
      @team = Team.find(params[:team_id]) if params[:team_id]
    else
      @user = current_user
      clear_user_temp_answers
      @team = current_user.teams.find(params[:team_id]) if params[:team_id]
    end
    @lo = Lo.includes(:introductions, :exercises).find(params[:id])
  end

  # change to auto sequence
  def next_page
    @lo = Lo.find(params[:id])
    @user = current_user
    @team = current_user.teams.find(params[:team_id])
    @sequence = Sequence::AutoSequence.find_or_create_by(lo_id: params[:id],
                                                         team_id: params[:team_id],
                                                         user_id: current_user.id)  

    puts "===================================="
    puts "CHAMOU CHAMOU NEXT PAGE de LOS CONTROLLER"
    puts "===================================="
    #@sequence.calculates
  end

private
  def clear_user_temp_answers
    answers = current_user.answers.or({team_id: nil}, {to_test: true})
    answers.destroy_all
    TipsCount.where(user_id: current_user.id, team_id: nil).destroy_all
  end
end

class ReportsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!
  before_filter :load_teams, except: :current_user_los

  def current_user_teams_los
    @teams = current_user.teams
  end

  def current_user_created_teams
  end

  def los_from_team
    @los = @teams.find(params[:team_id]).los
  end

  def learners_and_los_from_team
    team = @teams.find(params[:team_id])
    @los = team.los
    @learners = team.users.asc(:name)
  end

  def learner_report
    @team = @teams.find(params[:team_id])
    @lo = @team.los.find(params[:lo_id])
    @learner = @team.users.find(params[:learner_id])
    respond_to do |format|
      format.xls
      format.json
    end
  end

  def balancing_report
    @team = @teams.find(params[:team_id])
    @lo = @team.los.find(params[:lo_id])
    #debugger
    @learners = @team.users.asc(:name)
    statistics_database = Sequence::Statistic.where(lo_id: @lo.id).last
    @statistics = Array.new
    i = 0
    statistics_database.question_statistics.each do |qs|
      question = Question.find(qs[0])

      @statistics[i] = Array.new
      # veriricar se é possível inserir com label ao invez da posição
      @statistics[i][0] = qs[1]["difficulty_degree"].round(2)
      @statistics[i][1] = qs[1]["number_of_correct_response"]
      @statistics[i][2] = qs[1]["number_of_wrong_response"]
      @statistics[i][3] = @statistics[i][1] + @statistics[i][2]
      question_content = question.content;
      #Sera inserido em uma tabela, então retirar tags <p>
      question_content.slice! "<p>"
      question_content.slice! "</p>"
      # Html não esta lendo estes / Formatava o exercício incorretamente     
      question_content.gsub!("&nbsp;"," ")
        # &uacute; == ú, contudo gsub apreseta erro ao substituir com acento
      question_content.gsub!("&uacute;","u")  
      @statistics[i][4] = question.content
      i = i + 1  
    end
    #@statistics = @statistics.sort_by(&:first)
    @statistics.sort_by!(&:first)
  end

  def update_progress
    leanerReportFromteamLo = Reports::LearnerReport.find_by(lo_id: params[:lo_id], team_id: params[:team_id])
    Reports::LearnerReport.where(team_id: leanerReportFromteamLo.team_id, lo_id: leanerReportFromteamLo.lo_id).each do |student|
      if student.percentage_completed != 0 && student.exercises_done_amount == 0
         student.calculate
      end 
    end

    render nothing: true
  end

  def learners_progress
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

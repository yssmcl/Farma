class IntroductionsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!
  before_filter :find_lo
  before_filter :introductions

  #def index
  #  @introductions = @lo.introductions
  #end

  def create
    @introduction = @lo.introductions.build(params[:introduction])
    if @introduction.save
      respond_with(@lo, @introduction)
    else
      respond_with(@lo, @introduction, status: 422)
    end
  end

  def show
    @introduction = @lo.introductions.find(params[:id])
    respond_with(@lo, @introduction)
  end

  def update
    @introduction = @lo.introductions.find(params[:id])

    if @introduction.update_attributes(params[:introduction])
      respond_with(@lo, @introduction)
    else
      respond_with(@lo, @introduction, status: 422)
    end
  end

  def destroy
    @introduction = @lo.introductions.find(params[:id])
    @introduction.destroy
    respond_with(@lo, @introduction)
  end

private
 def find_lo
    if current_user.admin?
      @lo = Lo.find(params[:lo_id])
    else
      @lo = current_user.los.find(params[:lo_id])
    end
 end

 def introductions
   @introductions = @lo.introductions
 end
end

class LoContentsController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, :find_lo

  def index
    @exer_count = 1
    @intro_count = 1
  end

  def sort
    params[:ids].each_with_index do |id, index|
      contents = @lo.contents.select {|c| c.id === id}
      content = contents.first
      content.update_attribute(:position, index) if content
    end
    render nothing: true
  end

private
  def find_lo
    if current_user.admin?
      @lo = Lo.includes(:user).find(params[:id])
    else
      @lo = current_user.los.find(params[:id])
    end
  end

end

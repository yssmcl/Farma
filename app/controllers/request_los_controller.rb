class RequestLosController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!

  def petition
    request_lo = RequestLo.request(params[:lo_id]).to(current_user)
    call_rake :send_request_receive, request_id: request_lo.id
    #RequestLoMailer.send_receive_request(request_lo).deliver

    respond_to do |format|
      format.js { head 200 }
    end
  end

  def to_me
    @requests = current_user.requests_for_los_to_me.waiting
  end

  # Allow copy the lo requested
  def authorize
    @request = current_user.requests_for_los_to_me.find(params[:id])
    @request.authorize
    call_rake :send_request_authorized, request_id: @request.id

    respond_to do |format|
      format.js { head 200 }
    end
  end

  # Not allow copy the lo requested
  def not_authorize
    @request = current_user.requests_for_los_to_me.find(params[:id])
    @request.not_authorize
    call_rake :send_request_not_authorized, request_id: @request.id

    respond_to do |format|
      format.js { head 200 }
    end
  end
end

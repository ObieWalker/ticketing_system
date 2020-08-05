class RequestsController < ApplicationController
  before_action :authenticate
  before_action :agent_auth, only: [:update, :destroy, :show]
  before_action :set_request, only: [:update]
  include Pundit

  def index
    if request_search?
      requests = searchCondition
        json_response(RequestSerializer.new(requests, set_total(requests)))
    else
      requests = queryCondition
      json_response(RequestSerializer.new(requests, set_total(requests)))
    end
  end

  def create
    request = Request.create(request_attributes)
    if request
      json_response(request, status = :created)
    else
      json_response({ message: "Unable to create request."}, status = :bad_request)
    end
  end

  def show
    request = policy_scope(Request).monthly_export
    if request
      json_response(RequestSerializer.new(request))
    else
      json_response({ message: "There are no closed requests in the last month."}, status = :bad_request)
    end
  rescue StandardError => e
    json_response({ message: 'You cannot get this request.' }, status = :unauthorized)
  end

  def update
    if Request.update(params[:id], attribute)
      json_response({ message: "#{request_type}"})
    else
      json_response({ message: "Unable to update this request."}, status = :bad_request)
    end
  rescue StandardError => e
    json_response({ message: 'You cannot modify this request.' }, status = :unauthorized)
  end

  private

  def request_params
    params
    .require(:request)
    .permit(:request_title, :request_body)
  end

  def update_params
    params
    .require(:request)
    .permit(:status, :agent_assigned)
  end

  def attribute
    if update_params[:status].present?
      update_params[:status] == 2 ?
      {
        "closed_date": DateTime.now,
        "status": update_params[:status].to_i
      } :
      {
        "status": update_params[:status].to_i,
        "agent_assigned": update_params[:agent_assigned] || current_user.id
      }
    else
      {
        "agent_assigned": update_params[:agent_assigned] || current_user.id
      }
    end
  end

  def set_total(requests)
    options = {}
    options[:meta] = {total: requests.total_entries}
    options
  end

  def request_search?
    params[:q].present?
  end

  def request_type
    if update_params[:agent_assigned].present? && update_params[:status].present?
      "Agent assigned and status changed."
    elsif update_params[:status].present?
      "Status changed."
    else
      "Agent removed."
    end
  end

  def request_attributes
    {
      user_id: current_user.id,
      request_title: request_params[:request_title],
      request_body: request_params[:request_body]
    }
  end

  def set_request
    request = Request.find(params[:id])
    authorize request
  end

  def queryCondition
    if params[:status].empty?
      policy_scope(Request).get_all.paginate(
        page: params[:page], per_page: 5)
    else
      policy_scope(Request).where(status: params[:status]).paginate(
        page: params[:page], per_page: 5)
    end
  end

  def searchCondition
    if params[:status].empty?
    policy_scope(Request).get_all.ransack(request_title_cont: params[:q])
    .result.paginate(page: params[:page], per_page: 5)
    else
      policy_scope(Request).where(
        status: params[:status]).ransack(request_title_cont: params[:q])
        .result.paginate(page: params[:page], per_page: 5)
    end
  end
end

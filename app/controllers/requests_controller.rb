class RequestsController < ApplicationController
  before_action :agent_auth, only: [:index, :update, :destroy]
  before_action :set_request, only: [:update]
  include Pundit

  def index
    if request_search?
      requests = policy_scope(Request).where(status: params[:status]).ransack(request_title_cont: params[:q]).result.first(5)
      render json: RequestSerializer.new(requests)
    else
      requests = policy_scope(Request).where(status: params[:status]).paginate(page: params[:page], per_page: 10)
      render json: RequestSerializer.new(requests)
    end
  end

  def create
    request = Request.create(request_attributes)
    if request
      render json: request, status: :ok
    else
      render json: { message: "Unable to create request."}, status: :bad_request
    end
  end

  def show
    request = Request.find(params[:id])
    if request
      render json: RequestSerializer.new(request), status: :created
    else
      render json: { message: "Unable to get request."}, status: :bad_request
    end
  end

  def update
    if Request.update(params[:id], attribute)
      render json: { message: "#{request_type}"}, status: :ok
    else
      render json: { message: "Unable to update this request."}, status: :bad_request
    end
  rescue StandardError => e
    render json: { message: 'You cannot modify this request.' }, status: :unauthorized
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
        "status": update_params[:status]
      } :
      {
        "status": update_params[:status],
        "agent_assigned": update_params[:agent_assigned] || current_user.id
      }
    else
      {
        "agent_assigned": update_params[:agent_assigned] || current_user.id
      }
    end
  end

  def request_search?
    params[:q].present?
  end

  def request_type
    if update_params[:agent_assigned].present?
      "Agent assigned."
    elsif update_params[:agent_assigned].blank?
      "Agent removed."
    else
      "Status changed."
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
end

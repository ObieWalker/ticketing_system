class CommentsController < ApplicationController
  before_action :authenticate
  before_action :authorize_comment, only: :create
  before_action :set_comment, only: [:update, :destroy]
  include Pundit

  def create
    comment = Comment.create(create_params)
    if comment
      render json: comment, status: :ok
    else
      render json: { message: "Unable to comment at this time."}, status: :bad_request
    end
  end

  def update
    if Comment.update(params[:id], comment_attributes)
      render json: { message: "comment updated."}, status: :ok
    else
      render json: { message: "Unable to update this comment."}, status: :bad_request
    end
  rescue StandardError => e
    render json: { message: 'You are not allowed to update' }, status: :unauthorized
  end

  def destroy
    if Comment.destroy(params[:id])
      render json: { message: "Comment has been deleted"}, status: :ok
    else
      render json: { message: "Unable to delete comment."}, status: :bad_request
    end
  rescue StandardError => e
    render json: { message: 'You are not allowed to delete this comment.'}, status: :unauthorized
  end

  private

  def comment_params
    params
    .require(:comment)
    .permit(:request_id, :comment)
  end

  def create_params
    {
      user_id: current_user.id,
      request_id: comment_params[:request_id],
      comment: comment_params[:comment]
    }
  end

  def comment_attributes
    {
      comment: comment_params[:comment]
    }
  end

  def set_comment
    comment = Comment.find(params[:id])
    authorize comment
  end
end

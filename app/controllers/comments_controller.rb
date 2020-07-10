class CommentsController < ApplicationController
  before_action :authenticate
  before_action :check_comment_params, only: :create
  before_action :authorize_comment, only: :create
  before_action :set_comment, only: [:update, :destroy]
  include Pundit

  def create
    comment = Comment.create!(create_params)
    if comment
      json_response(comment)
    else
      json_response({ message: "Unable to comment at this time."}, status = :bad_request)
    end
  end

  def update
    if Comment.update(params[:id], comment_attributes)
      json_response({message: "comment updated."})
    else
      json_response({ message: "Unable to update this comment."}, status = :bad_request)
    end
  rescue StandardError => e
    json_response({ message: 'You are not allowed to update' }, status = :unauthorized)
  end

  def destroy
    if Comment.destroy(params[:id])
      json_response({message: "Comment has been deleted"})
    else
      json_response({ message: "Unable to delete comment."}, status = :bad_request)
    end
  rescue StandardError => e
    json_response({ message: 'You are not allowed to delete this comment.' }, status = :unauthorized)
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

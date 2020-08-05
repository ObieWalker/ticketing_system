class CommentsController < ApplicationController
  before_action :authenticate
  before_action :check_comment_params, only: :create
  before_action :authorize_comment, only: :create
  before_action :set_comment, only: [:update, :destroy]
  include Pundit

  def index 
    comments = Comment.where(request_id: params[:request_id]).order('created_at ASC')
    if comments
      json_response(comments)
    else
      json_response({ message: "There are no comments on this request."}, status = :not_found)
    end
  end

  def create
    comment, request =
      ActiveRecord::Base.transaction do
        [createComment, setRequestStatus]
      end
    json_response(comment, status = :created)
  rescue StandardError => e
    json_response({ message: 'There was a problem adding this comment.' }, status = :bad_request)
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

  def setRequestStatus
    Request.update(comment_params[:request_id], status: 1)
  end

  def set_comment
    comment = Comment.find(params[:id])
    authorize comment
  end

  def createComment
    Comment.create(create_params)
  end

  def authorize_comment
    first_request_comment = Comment.where(request_id: params[:comment]["request_id"]).empty?
    if current_user.role == 2 && first_request_comment
      json_response({message: "Unauthorized action."}, status = :unauthorized)
      return
    end
  end

  def check_comment_params
    if params[:comment].nil? || params[:comment]["request_id"].nil? || params[:comment]["comment"].nil?
      json_response({message: "Check user parameters."}, status = :bad_request)
      return
    end
  end
end

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :find_resource, only: %i[create]
  after_action :publish_comment, only: %i[create]

  authorize_resource

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user

    flash.now[:notice] = 'Comment posted successfully' if @comment.save
  end

  private

  def find_resource
    @klass = [Question, Answer].find { |klass| params["#{klass.name.underscore}_id"] }
    @resource = @klass.find(params["#{@klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def publish_comment
    return if @comment.errors.present?

    ActionCable.server.broadcast("#{@resource.class.name.downcase}-#{@resource.id}-comments", json_data)
  end

  def json_data
    {
      comment: @comment,
      resource: @resource.class.name.downcase,
      resource_id: @comment.commentable_id,
      resource_type: @comment.commentable_type,
      user_email: @comment.user.email,
      content: @comment.content
    }
  end
end

class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.create comment_params
    redirect_to article_path(Article.find params[:comment][:article_id]) + "#comment_#{@comment.id}"
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :article_id, :replied_to_id)
  end
end

class ArticlesController < ApplicationController
  def index
    @articles = Article.order(created_at: :desc).page params[:page]
  end

  def show
    @article = Article.friendly.find params[:id]
    @comment = @article.comments.build
  end
end

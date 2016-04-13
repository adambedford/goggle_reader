class ArticlesController < ApplicationController
  def bookmark
    @article = Article.find(params[:id])

    if @article.bookmark_for_user(current_user)
      redirect_to @article.feed, notice: "Article bookmarked"
    else
      redirect_to @article.feed, alert: "Unable to bookmark article"
    end
  end
end

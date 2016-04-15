class ArticlesController < ApplicationController
  def index
    @articles = current_user.articles
  end

  def bookmark
    @article = Article.find(params[:id])

    respond_to do |format|
      if (@bookmarked_article = @article.bookmark_for_user(current_user))
        format.js { render partial: "articles/article", locals: { article: @article } }
        format.html { redirect_to :back, notice: "Article bookmarked" }
      else
        format.js { render text: "Unable to bookmark article" }
        format.html { redirect_to :back, alert: "Unable to bookmark article" }
      end
    end
  end
end

class ArticlesController < ApplicationController
  def bookmark
    @article = Article.find(params[:id])

    respond_to do |format|
      if @bookmarked_article = @article.bookmark_for_user(current_user)
        format.html { redirect_to :back, notice: "Article bookmarked" }
        format.js { render partial: "feeds/article", locals: { article: @article } }
      else
        format.html { redirect_to :back, alert: "Unable to bookmark article" }
        format.js { render text: "Unable to bookmark article" }
      end
    end
  end
end

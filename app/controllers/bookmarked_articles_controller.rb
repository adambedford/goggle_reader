class BookmarkedArticlesController < ApplicationController
  def index
    if params[:feed_id].present?
      @bookmarked_articles = Article.bookmarked_by_user(current_user).for_feed(params[:feed_id])
    else
      @bookmarked_articles = Article.bookmarked_by_user(current_user)
    end

    @bookmarked_feeds = Feed.bookmarked_by_user(current_user)
  end

  def destroy
    @bookmarked_article = current_user.bookmarked_articles.find(params[:id])

    respond_to do |format|
      if @bookmarked_article.destroy
        format.js { render partial: "articles/article", locals: { article: @bookmarked_article.article } }
        format.html { redirect_to :back }
      else
        format.js { render text: "Unable to remove bookmark" }
        format.html { redirect_to :back, alert: "Unable to remove bookmark"}
      end
    end
  end

  protected

  def bookmarked_article_params
    params.require(:bookmarked_article).permit(:article_id)
  end
end

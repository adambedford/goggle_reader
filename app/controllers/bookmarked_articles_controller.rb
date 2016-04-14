class BookmarkedArticlesController < ApplicationController
  def index
    # TODO: Add scope to Article for this
    @bookmarked_articles = Article.where(id: current_user.bookmarked_articles.pluck(:article_id))
  end

  def create
    @bookmarked_article = current_user.bookmarked_articles.build(bookmarked_article_params)

    respond_to do |format|
      if @bookmarked_article.save
        format.html { redirect_to bookmarked_articles_path, notice: "Article bookmarked" }
        format.js { render partial: "feeds/article", locals: { article: @bookmarked_article.article } }
      else
        format.html { redirect_to bookmarked_articles_path, alert: "Unable to bookmark article" }
        format.js { render text: "Unable to bookmark article" }
      end
    end
  end

  def destroy
    @bookmarked_article = current_user.bookmarked_articles.find(params[:id])

    respond_to do |format|
      if @bookmarked_article.destroy
        format.html { redirect_to bookmarked_articles_path }
        format.js { render partial: "feeds/article", locals: { article: @bookmarked_article.article } }
      else
        format.html { redirect_to bookmarked_articles_path, alert: "Unable to remove bookmark"}
        format.js { render text: "Unable to remove bookmark" }
      end
    end
  end

  protected

  def bookmarked_article_params
    params.require(:bookmarked_article).permit(:article_id)
  end
end

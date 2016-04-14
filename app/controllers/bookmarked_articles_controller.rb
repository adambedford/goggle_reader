class BookmarkedArticlesController < ApplicationController
  def index
    @bookmarked_articles = Article.where(id: current_user.bookmarked_articles.pluck(:article_id))
  end

  def destroy
    @bookmarked_article = current_user.bookmarked_articles.find(params[:id])

    @bookmarked_article.destroy!

    redirect_to bookmarked_articles_path
  end
end

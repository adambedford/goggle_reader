module ApplicationHelper
  def bookmark_article_link(article)
    bookmark = article.user_bookmarks.for_user(current_user).first

    if article.bookmarked_by_user?(current_user)
      link_to bookmark, method: :delete do
        content_tag(:i, "star", class: "material-icons")
      end
    else
      link_to bookmark_feed_article_path(article.feed,article) do
        content_tag(:i, "star_outline", class: "material-icons")
      end
    end
  end
end

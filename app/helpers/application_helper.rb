module ApplicationHelper
  def bookmark_article_link(article)
    bookmark = article.user_bookmarks.for_user(current_user).first

    if article.bookmarked_by_user?(current_user)
      link_to bookmark, method: :delete, class: "bookmark-toggle-link" do
        content_tag(:i, "star", class: "material-icons")
      end
    else
      bookmark_article_post_link(article)
    end
  end

  def bookmark_article_post_link(article)
    link_to bookmarked_articles_path(bookmarked_article: { article_id: article.id}, format: :js),
            class: "bookmark-toggle-link",
            method: :post do
      content_tag(:i, "star_outline", class: "material-icons")
    end
  end

  def feed_link(name, path, options = {})
    active_class = "active"

    if request.fullpath == path
      if options.has_key?(:class)
        options[:class] << " "
        options[:class] << active_class
      else
        options[:class] = active_class
      end
    end

    link_to(name, path, options)
  end
end

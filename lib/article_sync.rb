class ArticleSync
  def initialize(feed)
    @feed = feed
  end

  def sync
    feed_entries.map { |entry| create_or_update_article(entry) }
  end

  private

  attr_reader :feed

  def feed_entries
    @feed_entries ||= Feedjira::Feed.fetch_and_parse(feed.url).entries
  end

  def create_or_update_article(entry)
    Article.find_or_initialize_by(external_id: entry.id).tap do |article|
      article.feed = feed
      article.title = entry.title
      article.summary = entry.summary
      article.url = entry.url
      article.published_at = entry.published
      article.save
    end
  end
end

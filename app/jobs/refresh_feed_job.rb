class RefreshFeedJob < ActiveJob::Base
  queue_as :default

  def perform(feed)
    ArticleSync.new(feed).sync
    feed.last_refresh_at = Time.now
    feed.save
  rescue
    puts "Error refreshing feed #{feed.id}"
  end
end

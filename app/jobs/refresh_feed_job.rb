class RefreshFeedJob < ActiveJob::Base
  queue_as :default

  def perform(feed)
    puts "START: Refreshing Feed #{feed.id}"

    ArticleSync.new(feed).sync
    feed.last_refresh_at = Time.now
    feed.save

    puts "DONE: Refreshing Feed #{feed.id}"
  rescue
    puts "Error refreshing feed #{feed.id}"
  end
end

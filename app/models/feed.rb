class Feed < ActiveRecord::Base
  belongs_to :user, inverse_of: :feeds

  has_many :articles, inverse_of: :feed

  validates :url, presence: true

  before_create :fetch_feed_and_load_title

  def name
    cached_title || url.truncate(50)
  end

  def refresh!
    ArticleSync.new(self).sync
  end

  protected

  def fetch_feed_and_load_title
    feed = Feedjira::Feed.fetch_and_parse(url)
    self.cached_title = feed.title
  rescue
    nil
  end
end

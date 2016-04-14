class Feed < ActiveRecord::Base
  has_many :feed_subscriptions, dependent: :destroy
  has_many :users, through: :feed_subscriptions

  has_many :articles, inverse_of: :feed

  validates :url, presence: true

  before_create :fetch_feed_and_load_title
  after_create :refresh!

  def name
    cached_title || url.truncate(50)
  end

  def refresh!
    RefreshFeedJob.perform_now(self)
  end

  def refresh_later!
    RefreshFeedJob.perform_later(self)
  end

  protected

  def fetch_feed_and_load_title
    feed = Feedjira::Feed.fetch_and_parse(url)
    self.cached_title = feed.title
  rescue
    nil
  end
end

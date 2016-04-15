class Feed < ActiveRecord::Base
  has_many :feed_subscriptions, dependent: :destroy
  has_many :users, through: :feed_subscriptions

  has_many :articles, inverse_of: :feed, dependent: :destroy

  validates :url, presence: true

  before_create :fetch_feed_and_load_title
  after_create :refresh!

  scope :bookmarked_by_user, ->(user) do
    def self.bookmarked_articles(user)
      BookmarkedArticle.preload(:article).for_user(user)
    end

    where(id: bookmarked_articles(user).map { |bookmark| bookmark.article.feed_id })
  end

  def name
    cached_title || url.truncate(50)
  end

  def refresh!
    RefreshFeedJob.perform_now(self)
  end

  def refresh_later!
    RefreshFeedJob.perform_later(self)
  end

  def unsubscribe_user(user)
    subscription = feed_subscriptions.where(user: user).first
    return unless subscription

    subscription.destroy
  end

  protected

  def fetch_feed_and_load_title
    feed = Feedjira::Feed.fetch_and_parse(url)
    self.cached_title = feed.title
  rescue
    nil
  end
end

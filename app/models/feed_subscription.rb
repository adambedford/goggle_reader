class FeedSubscription < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user

  validates_uniqueness_of :user_id, message: "already subscribed to this feed", scope: [:feed_id]
end

class Article < ActiveRecord::Base
  belongs_to :feed, inverse_of: :articles

  validates :feed_id, presence: true
  validates :title, presence: true
  validates :url, presence: true

  default_scope -> { order("published_at DESC") }
end

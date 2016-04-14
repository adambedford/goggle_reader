class Article < ActiveRecord::Base
  belongs_to :feed, inverse_of: :articles

  has_many :user_bookmarks, class_name: "BookmarkedArticle"
  has_many :users, through: :user_bookmarks

  validates :feed_id, presence: true
  validates :title, presence: true
  validates :url, presence: true

  scope :bookmarked_by_user, ->(user) { where(id: user.bookmarked_articles.pluck(:article_id)) }

  default_scope -> { order("published_at DESC") }

  def bookmark_for_user(user)
    user.bookmarked_articles.create(article: self)
  end

  def bookmarked_by_user?(user)
    user.bookmarked_articles.where(article: self).any?
  end
end

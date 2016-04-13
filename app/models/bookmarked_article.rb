class BookmarkedArticle < ActiveRecord::Base
  belongs_to :article, inverse_of: :user_bookmarks
  belongs_to :user, inverse_of: :bookmarked_articles
end

require 'rails_helper'

describe BookmarkedArticle, type: :model do
  describe "associations" do
    it { should belong_to(:user).inverse_of(:bookmarked_articles) }
    it { should belong_to(:article).inverse_of(:user_bookmarks) }
  end
end

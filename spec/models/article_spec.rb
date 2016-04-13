require 'rails_helper'

describe Article, type: :model do
  subject { create(:article) }

  describe "associations" do
    it { should belong_to(:feed).inverse_of(:articles) }
    it { should have_many(:users).through(:user_bookmarks) }
  end

  describe "validations" do
    it { should validate_presence_of(:feed_id) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
  end

  describe "scopes" do
    let(:article_1) { create(:article, published_at: 1.day.ago) }
    let(:article_2) { create(:article, published_at: Time.now) }

    it "should have default scope to order by published_at, descending" do
      expect(Article.all).to eq [article_2, article_1]
    end
  end

  describe "bookmarking" do
    let(:user) { create(:user) }

    describe "#bookmark_for_user" do
      it "creates a bookmarked article record for the given user" do
        expect { subject.bookmark_for_user(user) }.to change { BookmarkedArticle.count }.by(1)
      end
    end

    describe "#bookmarked_by_user?" do
      context "when the given user has bookmarked the article" do
        before do
          create(:bookmarked_article, user: user, article: subject)
        end
        it "returns true" do
          expect(subject.bookmarked_by_user?(user)).to be_truthy
        end
      end

      context "when the given user has not bookmarked the article" do
        before do
          user.bookmarked_articles.delete_all
        end

        it "returns false" do
          expect(subject.bookmarked_by_user?(user)).to be_falsey
        end
      end
    end
  end
end

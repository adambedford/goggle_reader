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

    describe "default scope" do
      it "should have default scope to order by published_at, descending" do
        expect(Article.all.to_sql).to eq Article.order("published_at DESC").to_sql
      end
    end

    describe "bookmarked_by_user scope" do
      let(:bob) { create(:user) }
      let(:jane) { create(:user, name: "Jane") }
      let!(:bob_bookmark) { create(:bookmarked_article, article: article_1, user: bob) }
      let!(:jane_bookmark) { create(:bookmarked_article, article: article_2, user: jane) }

      it "returns a collection of the given user's articles" do
        expect(described_class.bookmarked_by_user(bob)).to include article_1
      end

      it "does not include articles bookmarked by another user" do
        expect(described_class.bookmarked_by_user(bob)).to_not include article_2
      end
    end

    describe "for_feed scope" do
      let!(:feed_1) { create(:feed) }
      let!(:feed_2) { create(:feed) }
      let!(:feed_1_article) { create(:article, feed: feed_1) }
      let!(:feed_2_article) { create(:article, feed: feed_2) }

      it "returns a collection of the given feed's articles" do
        expect(described_class.for_feed(feed_1)).to include feed_1_article
      end

      it "does not include articles from another feed" do
        expect(described_class.for_feed(feed_1)).to_not include feed_2_article
      end

      it "works can receive either a feed object or a feed ID" do
        expect(described_class.for_feed(feed_1.id)).to include feed_1_article
      end
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

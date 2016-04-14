require 'rails_helper'

describe Feed, type: :model do
  VCR_OPTIONS = { cassette_name: "Feed/bbc_news_world" }

  subject { create(:feed) }

  describe "associations" do
    it { should have_many(:articles).inverse_of(:feed) }
  end

  describe "validations" do
    it { should validate_presence_of(:url)}
  end

  describe "scopes" do
    describe "bookmarked_by_user" do
      let(:user) { create(:user) }
      let(:feed_1) { create(:feed) }
      let(:feed_2) { create(:feed) }
      let(:article_1) { create(:article, feed: feed_1) }
      let(:article_2) { create(:article, feed: feed_2) }
      let!(:bookmark_1) { create(:bookmarked_article, article: article_1, user: user)}

      it "returns a collection of feeds for articles that the given user has bookmarked" do
        expect(described_class.bookmarked_by_user(user)).to include(feed_1)
      end

      it "does not include feeds if a user has not bookmarked an article for those feeds" do
        expect(described_class.bookmarked_by_user(user)).to_not include(feed_2)
      end
    end
  end

  describe "#name" do
    context "when the cached title is present" do
      subject do
        create(:feed).tap do |feed|
          feed.cached_title = "BBC News Feed"
        end
      end

      it "returns the cached title" do
        expect(subject.name).to eq subject.cached_title
      end
    end

    context "when the cached title is not present" do
      subject do
        create(:feed).tap do |feed|
          feed.cached_title = nil
        end
      end

      context "when the URL is longer than 50 characters" do
        it "gets truncated with ellipses appended" do
          expect(subject.name).to eq(subject.url.truncate(50))
        end
      end

      context "when the URL is shorter than 50 characters" do
        subject { Feed.create(url: "http://short.url/feed") }

        it "does not get truncated" do
          expect(subject.name).to eq(subject.url)
        end
      end
    end
  end

  describe "callbacks" do
    describe "before_save" do
      describe "setting the feed cached name", vcr: VCR_OPTIONS do
        it "loads the feed and caches the title" do
          expect(subject.cached_title).to eq "BBC News - World"
        end
      end
    end
  end

  describe "#refresh!" do
    it "updates the last_refresh_at timestamp" do
      subject.refresh!
      expect(subject.last_refresh_at).to be_within(5.seconds).of(Time.now)
    end
  end

  describe "#refresh_later!" do
    it "enqueues the job" do
      expect { subject.refresh_later! }.to enqueue_a(RefreshFeedJob).with(global_id(subject))
    end
  end
end

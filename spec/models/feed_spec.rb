require 'rails_helper'

describe Feed, type: :model do
  VCR_OPTIONS = { cassette_name: "Feed/bbc_news_world" }

  subject { create(:feed) }

  describe "associations" do
    it { should belong_to(:user).inverse_of(:feeds) }
    it { should have_many(:articles).inverse_of(:feed) }
  end

  describe "validations" do
    it { should validate_presence_of(:url)}
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
end

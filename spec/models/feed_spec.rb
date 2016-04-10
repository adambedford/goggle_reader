require 'rails_helper'

RSpec.describe Feed, type: :model do
  subject { create(:feed) }

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
        expect(subject.name).to eq "BBC News Feed"
      end
    end

    context "when the cached title is not present" do
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
end

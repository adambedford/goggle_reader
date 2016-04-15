require 'rails_helper'

VCR_OPTIONS = { cassette_name: "Feed/bbc_news_world" }

describe ArticleSync, vcr: VCR_OPTIONS do
  def create_or_update_article(entry)
    sync.send(:create_or_update_article, entry)
  end

  let(:feed) { create(:feed) }
  let(:entries) { Feedjira::Feed.fetch_and_parse(feed.url).entries }
  let(:entry) { entries.last }
  let(:sync) { ArticleSync.new(feed) }

  describe "#sync" do
    describe "give a single instance of feed" do

      it "returns an array of Articles" do
        expect(sync.sync).to be_a(Array)
        expect(sync.sync.first).to be_a(Article)
      end

      context "when the feed has new entries" do
        it "creates a new Article record for each new article" do
          expect { sync.sync }.to change { Article.count }
        end
      end
    end
  end

  describe "#create_or_update_article" do
    context "when the article is new" do
      it "creates a new article" do
        expect { sync.sync }.to change { Article.count }
        expect(Article.unscoped.last.external_id).to eq entry.id
      end
    end

    context "when the article is existing" do
      context "when the article has not changed" do
        let(:article) { create(:article, title: entry.title, external_id: entry.id) }

        it "does nothing" do
          expect { (create_or_update_article(entry)) }.to_not change { article.updated_at }
        end
      end

      context "when the article has changed" do
        let(:new_title) { "New Article Title" }
        let(:article) { create(:article, title: new_title, external_id: entry.id) }

        it "updates the article" do
          create_or_update_article(entry)
          expect(article.title).to eq new_title
        end
      end
    end
  end

end
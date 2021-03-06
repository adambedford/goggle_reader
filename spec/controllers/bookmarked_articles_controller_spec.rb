require 'rails_helper'

describe BookmarkedArticlesController, type: :controller do
  describe "GET index" do
    def do_request(options = {})
      get(:index, options)
    end

    let(:user) { create(:user) }
    let(:feed_1) { create(:feed) }
    let(:feed_2) { create(:feed) }
    let(:article_1) { create(:article, feed: feed_1) }
    let(:article_2) { create(:article, feed: feed_2) }
    let!(:bookmark_1) { create(:bookmarked_article, article: article_1, user: user) }
    let!(:bookmark_2) { create(:bookmarked_article, article: article_2, user: user) }

    before do
      sign_in(user)
    end

    it "is successful" do
      expect(do_request).to be_successful
    end

    context "without a feed_id param" do
      it "returns all bookmarked articles" do
        do_request
        expect(assigns(:bookmarked_articles)).to include(article_1, article_2)
      end
    end

    context "with a feed_id param" do
      it "returns only the articles for the given feed"do
        do_request(feed_id: feed_1.id)
        expect(assigns(:bookmarked_articles)).to include(article_1)
        expect(assigns(:bookmarked_articles)).to_not include(article_2)
      end
    end


  end

  describe "DELETE destroy" do
    def do_request(options = {})
      delete(:destroy, options)
    end

    let(:user) { create(:user) }
    let(:feed) { create(:feed) }

    before(:each) do
      sign_in(user)
      request.env["HTTP_REFERER"] = feed_path(feed)
    end

    context "when the bookmarked article belongs to the user" do
      before(:each) do
        @bookmarked_article = create(:bookmarked_article, user: user)
      end

      it "deletes the bookmarked article" do
        expect { (do_request(id: @bookmarked_article.id)) }.to change { BookmarkedArticle.count }.by(-1)
      end

      it "redirects to the where it came from" do
        expect(do_request(id: @bookmarked_article.id)).to redirect_to feed_path(feed)
      end
    end

    context "when the bookmarked article does not belong to the user" do
      let(:jane) { create(:user, name: "Jane")}
      let(:bookmarked_article_for_jane) { create(:bookmarked_article, user: jane)}

      it "raises an Not Found" do
        expect {
          do_request(id: bookmarked_article_for_jane.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end

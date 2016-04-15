require 'rails_helper'

describe ArticlesController, type: :controller do
  describe "GET index" do
    def do_request(options = {})
      get(:index, options)
    end

    let(:bob) { create(:user, name: "Bob") }
    let(:jane) { create(:user, name: "Jane") }
    let(:feed_1) { create(:feed) }
    let(:feed_2) { create(:feed) }
    let(:article_for_bob) { create(:article, feed: feed_1) }
    let(:article_for_jane) { create(:article, feed: feed_2) }
    let!(:subscription_1) { create(:feed_subscription, feed: feed_1, user: bob) }
    let!(:subscription_2) { create(:feed_subscription, feed: feed_2, user: jane) }

    before do
      sign_in(bob)
    end

    it "returns success code" do
      expect(do_request).to be_success
    end

    describe "scoping to current user" do
      it "loads all articles for the signed in user" do
        do_request
        expect(assigns(:articles)).to be_a(ActiveRecord::Relation)
        expect(assigns(:articles)).to include(article_for_bob)
      end

      it "does not load articles for another user" do
        do_request
        expect(assigns(:articles)).to_not include(article_for_jane)
      end
    end
  end

  describe "GET bookmark" do
    def do_request(options = {})
      get(:bookmark, options)
    end

    let(:user) { create(:user) }
    let(:feed) { create(:feed) }
    let(:article) { create(:article) }

    before(:each) do
      sign_in(user)
      request.env["HTTP_REFERER"] = feed_path(article.feed)
      do_request(feed_id: feed.id, id: article.id)
    end

    it "locates the article" do
      expect(assigns(:article)).to eq article
    end

    context "redirection" do
      it "redirects to the feed path" do
        expect(response).to redirect_to article.feed
      end
    end
  end
end

require 'rails_helper'

describe ArticlesController, type: :controller do
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

      context "when successful" do
        it "has a success flash message" do
          expect(controller).to set_flash[:notice].to "Article bookmarked"
        end
      end
    end
  end
end

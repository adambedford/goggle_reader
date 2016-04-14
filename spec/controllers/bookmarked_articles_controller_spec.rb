require 'rails_helper'

describe BookmarkedArticlesController, type: :controller do
  describe "POST create" do
    def do_request(options = {})
      post(:create, options)
    end

    let(:user) { create(:user) }
    let(:feed) { create(:feed) }
    let(:article) { create(:article) }

    before(:each) do
      sign_in(user)
      request.env["HTTP_REFERER"] = bookmarked_articles_path
      do_request(bookmarked_article: { article_id: article.id })
    end

    it "builds a new bookmarked article for the current user and given article" do
      expect(assigns(:bookmarked_article).article).to eq article
      expect(assigns(:bookmarked_article).user).to eq user
    end

    context "redirection" do
      it "redirects to the feed path" do
        expect(response).to redirect_to bookmarked_articles_path
      end

      context "when successful" do
        it "has a success flash message" do
          expect(controller).to set_flash[:notice].to "Article bookmarked"
        end
      end
    end
  end

  describe "DELETE destroy" do
    def do_request(options = {})
      delete(:destroy, options)
    end

    let(:user) { create(:user) }

    before(:each) do
      sign_in(user)
    end

    context "when the bookmarked article belongs to the user" do
      before(:each) do
        @bookmarked_article = create(:bookmarked_article, user: user)
      end

      it "deletes the bookmarked article" do
        expect { (do_request(id: @bookmarked_article.id)) }.to change { BookmarkedArticle.count }.by(-1)
      end

      it "redirects to the bookmarked articles path" do
        expect(do_request(id: @bookmarked_article.id)).to redirect_to bookmarked_articles_path
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

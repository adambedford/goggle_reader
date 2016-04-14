require 'rails_helper'

describe BookmarkedArticlesController, type: :controller do
  describe "DELETE destroy" do
    def do_request(options = {})
      delete(:destroy, options)
    end

    let(:user) { create(:user) }
    let(:bookmarked_article) { create(:bookmarked_article, user: user) }

    before(:each) do
      sign_in(user)
    end

    context "when the bookmarked article belongs to the user" do
      it "deletes the bookmarked article" do
        expect { (do_request(id: bookmarked_article.id)) }.to change { BookmarkedArticle.count }.by(-1)
      end

      it "redirects to the bookmarked articles path" do
        expect(do_request(id: bookmarked_article.id)).to redirect_to bookmarked_articles_path
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

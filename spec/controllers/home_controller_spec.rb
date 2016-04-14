require 'rails_helper'

describe HomeController, type: :controller do
  describe "GET index" do
    def do_request(options = {})
      get(:index, options)
    end

    let(:user) { create(:user) }

    context "when the user is not signed in" do
      it "renders the signed out page" do
        expect(do_request).to render_template("application/_signed_out_index")
      end
    end

    context "when the user is signed in" do
      before do
        sign_in(user)
      end

      it "redirects to the articles index" do
        expect(do_request).to redirect_to articles_path
      end
    end
  end
end

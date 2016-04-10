require 'rails_helper'

RSpec.describe FeedsController, type: :controller do
  describe "GET index" do
    def do_request(options = {})
      get(:index, options)
    end

    it "returns success code" do
      expect(do_request).to be_success
    end

    it "returns all feeds" do
      do_request
      expect(assigns(:feeds)).to be_a(ActiveRecord::Relation)
    end
  end

  describe "GET new" do
    def do_request(options = {})
      get(:new, options)
    end

    it "assigns a new instance of Feed" do
      do_request
      expect(assigns(:feed)).to be_a(Feed)
    end

    it "renders the new feed template" do
      expect(do_request).to render_template(:new)
    end
  end

  describe "POST create" do
    def do_request
      post(:create, feed: attributes)
    end

    context "when valid" do
      let(:attributes) { attributes_for(:feed) }
      let(:feed) { create(:feed) }

      it "creates the feed" do
        do_request
        expect(assigns(:feed)).to be_a(Feed)
      end

      it "increments the feed count" do
        expect { do_request }.to change { Feed.count }.by(1)
      end

      it "redirects to the root path with a success message" do
        expect(do_request).to redirect_to root_path
        expect(controller).to set_flash[:notice]
      end
    end

    context "when invalid" do
      let(:attributes) { { url: '' } }

      it "does not change the feed count" do
        expect{ do_request }.to_not change { Feed.count }
      end

    end
  end

end

require 'rails_helper'

VCR_OPTIONS = { cassette_name: "Feed/bbc_news_world" }

describe FeedsController, type: :controller, vcr: VCR_OPTIONS do
  let(:feed_for_bob) { create(:feed, user: bob) }
  let(:feed_for_jane) { create(:feed, user: jane) }
  let(:bob) { create(:user) }
  let(:jane) { create(:user, name: "Jane") }

  describe "GET index" do
    def do_request(options = {})
      get(:index, options)
    end

    before do
      sign_in(bob)
    end

    it "returns success code" do
      expect(do_request).to be_success
    end

    describe "scoping to current user" do
      it "loads all feeds for the signed in user" do
        do_request
        expect(assigns(:feeds)).to be_a(ActiveRecord::Relation)
        expect(assigns(:feeds)).to include(feed_for_bob)
      end

      it "does not load feeds for another user" do
        do_request
        expect(assigns(:feeds)).to_not include(feed_for_jane)
      end
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

  describe "GET show" do
    def do_request(options = {})
      get(:show, options)
    end

    before do
      sign_in(bob)
      do_request(id: feed_for_bob.id)
    end

    it "loads all feeds for the signed in user" do
      expect(assigns(:feeds)).to be_a(ActiveRecord::Relation)
      expect(assigns(:feeds)).to include(feed_for_bob)
    end

    it "does not load feeds for another user" do
      sign_in(bob)
      do_request(id: feed_for_bob.id)
      expect(assigns(:feeds)).to_not include(feed_for_jane)
    end

    it "finds the correct instance of Feed" do
      do_request(id: feed_for_bob.id)
      expect(assigns(:feed)).to eq feed_for_bob
    end

    it "raises a Not Found when given an ID belonging to another user" do
      expect {
        do_request(id: feed_for_jane.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "fetches the feed articles" do
      do_request(id: feed_for_bob.id)
      expect(assigns(:articles).first).to be_a(Feedjira::Parser::RSSEntry)
    end
  end
end

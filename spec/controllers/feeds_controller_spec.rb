require 'rails_helper'

VCR_OPTIONS = { cassette_name: "Feed/bbc_news_world" }

describe FeedsController, type: :controller, vcr: VCR_OPTIONS do
  let(:feed_for_bob) { create(:feed) }
  let(:feed_for_jane) { create(:feed) }
  let(:bob) { create(:user) }
  let(:jane) { create(:user, name: "Jane") }

  before do
    create(:feed_subscription, feed: feed_for_bob, user: bob)
    create(:feed_subscription, feed: feed_for_jane, user: jane)
  end

  describe "GET new" do
    def do_request(options = {})
      get(:new, options)
    end

    before do
      sign_in(bob)
    end

    it "assigns a new instance of Feed" do
      do_request
      expect(assigns(:feed)).to be_a(Feed)
      expect(assigns(:feed).users).to include bob
    end

    it "renders the new feed template" do
      expect(do_request).to render_template(:new)
    end
  end

  describe "POST create" do
    def do_request
      post(:create, feed: attributes)
    end

    before do
      sign_in(bob)
    end

    context "when valid" do
      let(:attributes) { attributes_for(:feed) }

      context "when it is a brand new feed" do
        before do
          Feed.destroy_all
        end

        it "increments the feed count" do
          expect { do_request }.to change { Feed.count }.by(1)
        end

        it "creates a new Feed and subscribes the user to it" do
          do_request
          expect(assigns(:feed)).to be_a(Feed)
          expect(assigns(:feed).users).to include bob
        end
      end

      before(:each) do
        FeedSubscription.delete_all
      end

      context "when the feed already exists" do
        let(:feed) { create(:feed) }

        it "doesn't create a new feed" do
          expect { do_request }.to_not change { Feed.count }
        end

        it "it subscribes the user to it" do
          expect { do_request }.to change { FeedSubscription.count }.by(1)
          expect(FeedSubscription.last.user).to eq bob
        end
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

    it "finds the correct instance of Feed" do
      do_request(id: feed_for_bob.id)
      expect(assigns(:feed)).to eq feed_for_bob
    end

    it "raises a Not Found when given an ID belonging to another user" do
      expect {
        do_request(id: feed_for_jane.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET refresh" do
    def do_request(options = {})
      get(:refresh, options)
    end

    before(:each) do
      sign_in(bob)
      do_request(id: feed_for_bob.id)
    end

    it "redirects to the feed path if the refresh was successful" do
      expect(response).to redirect_to feed_for_bob
    end

    it "raises a Not Found when given a feed ID belonging to another user" do
      expect {
        do_request(id: feed_for_jane.id)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

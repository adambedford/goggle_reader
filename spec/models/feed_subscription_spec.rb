require 'rails_helper'

describe FeedSubscription, type: :model do
  let(:user) { create(:user) }
  let(:feed) { create(:feed) }

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:feed) }
  end

  describe "validations" do
    describe "a user can only have one subscription to a particular feed" do
      context "when the user is not subscribed" do
        before do
          user.feed_subscriptions.delete_all
        end

        let(:feed_subscription) { build(:feed_subscription, user: user, feed: feed) }

        it "allows the user to subscribe to the feed" do
          expect(feed_subscription).to be_valid
          expect { feed_subscription.save }.to change { FeedSubscription.count }.by(1)
          expect(FeedSubscription.last).to eq feed_subscription
        end
      end

      context "when the user is already subscribed" do
        before do
          create(:feed_subscription, user: user, feed: feed)
        end

        let(:duplicate_feed_subscription) { build(:feed_subscription, user: user, feed: feed) }


        it "prevents subscription" do
          expect(duplicate_feed_subscription).to_not be_valid
          expect(duplicate_feed_subscription.save).to be_falsey
        end

        it "shows an informative error message" do
          duplicate_feed_subscription.save
          expect(duplicate_feed_subscription.errors.full_messages).to include "User already subscribed to this feed"
        end
      end
    end
  end
end

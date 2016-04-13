require 'rails_helper'

describe FeedSubscription, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:feed) }
  end
end

require 'rails_helper'

describe Article, type: :model do
  subject { create(:article) }

  describe "associations" do
    it { should belong_to(:user).inverse_of(:articles) }
    it { should belong_to(:feed).inverse_of(:articles) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:feed_id) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
  end
end

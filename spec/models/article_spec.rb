require 'rails_helper'

describe Article, type: :model do
  subject { create(:article) }

  describe "associations" do
    it { should belong_to(:feed).inverse_of(:articles) }
  end

  describe "validations" do
    it { should validate_presence_of(:feed_id) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }
  end

  describe "scopes" do
    let(:article_1) { create(:article, published_at: 1.day.ago) }
    let(:article_2) { create(:article, published_at: Time.now) }

    it "should have default scope to order by published_at, descending" do
      expect(Article.all).to eq [article_2, article_1]
    end
  end
end

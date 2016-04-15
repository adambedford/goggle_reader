require 'rails_helper'

describe CleanupOldArticlesJob, type: :job do
  context "when given an expiry" do
    let(:expiry) { 10.days.ago }
    let(:new_article) { create(:article, published_at: Date.yesterday) }
    let(:old_article) { create(:article, published_at: Date.today.last_month) }

    it "cleans up articles older than the given expiry" do
      expect(Article.all).to include(new_article, old_article)
      described_class.perform_now(expiry)
      expect(Article.all).to_not include(old_article)
    end
  end

  context "when not given an expiry" do
    let(:new_article) { create(:article, published_at: Date.yesterday) }
    let(:old_article) { create(:article, published_at: (Date.today - 8.days)) }

    it "uses the default expiry" do
      expect(Article.all).to include(new_article, old_article)
      described_class.perform_now
      expect(Article.all).to_not include(old_article)
    end
  end
end

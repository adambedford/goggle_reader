class CleanupOldArticlesJob < ActiveJob::Base
  queue_as :default

  EXPIRY = 7.days.ago

  def perform(expiry = EXPIRY)
    Article.where("published_at < ?", expiry).delete_all
  end
end

class Feed < ActiveRecord::Base
  validates :url, presence: true

  def name
    cached_title || url.truncate(50)
  end
end

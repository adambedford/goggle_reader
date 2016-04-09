class Feed < ActiveRecord::Base
  validates :url, presence: true
end

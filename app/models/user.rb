class User < ActiveRecord::Base
  validates :name, presence: true
  validates :uid, presence: true
  validates :provider, presence: true

  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth["provider"], uid: auth["uid"]).tap do |user|
      user.name = auth["info"]["name"]
      user.save!
    end
  end
end

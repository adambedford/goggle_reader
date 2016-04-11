FactoryGirl.define do
  factory :feed do
    url "http://feeds.bbci.co.uk/news/world/rss.xml?edition=uk"
    user
  end
end
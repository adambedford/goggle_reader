FactoryGirl.define do
  factory :article do
    title   "Interesting Article"
    summary "Many interesting things happened today. Here's one of them!"
    url     "http://news-source.com/article.php"
    external_id "1"
    feed
    user
  end
end

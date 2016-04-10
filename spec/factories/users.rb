FactoryGirl.define do
  factory :user do
    provider "Google"
    uid      "12345"
    name     "Bob User"
  end
end

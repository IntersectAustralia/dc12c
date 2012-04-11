# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :access_request do
    status 'CREATED'
    association :papyrus
    association :user
    date_requested '04/04/2011'
  end
end
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :genre do
    sequence(:name){|n| "genre #{n}"}
  end
end
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :language do
    sequence(:name){|n| "language #{n}"}
  end
end
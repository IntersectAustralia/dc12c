# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :language do
    sequence(:name){|n| "language #{n}"}
    sequence(:code){|n| "code #{n}"}
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :name do
    association :papyrus
    name 'some_name'
  end
end

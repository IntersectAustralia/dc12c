# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :connection do
    association :papyrus
    association :related_papyrus, factory: :papyrus
    description 'some_description'
  end
end

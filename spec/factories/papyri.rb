# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :papyrus do
    sequence(:inventory_id){|n| n.to_s}
  end
end


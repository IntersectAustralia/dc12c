# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :papyrus do
    sequence(:mqt_number){|n| n.to_s}
    sequence(:inventory_number){|n| n.to_s}
  end
end


# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection do
    sequence(:title){|n| "Collection #{n}"}
    description "Some Description"
    keywords "Some keywords"
  end
end


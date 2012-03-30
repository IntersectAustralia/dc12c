# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image do
    image_file_name 'img.tiff'
    caption 'caption'
    association :papyrus
  end
end

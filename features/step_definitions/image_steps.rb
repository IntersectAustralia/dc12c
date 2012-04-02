When /^I attach image "(.*)"$/ do |filename|
  attach_image(filename)
end

And /^"(.*)" should have (\d+) image(s)?$/ do |inventory_id, num_images, _|
  Papyrus.find_by_inventory_id!(inventory_id).images.count.should eq num_images.to_i
end

And /^I should see low res image for "(.*)" of papyrus "(.*)"$/ do |image_name, papyrus_name|
  papyrus = Papyrus.find_by_inventory_id!(papyrus_name)
  image = papyrus.images.find_by_image_file_name!(image_name)
  page.should have_css(%Q{img[src*="/image/#{image.id}/low_res"]})
end
Then /^I should (not )?see "Download in (high|low) resolution" for "(.*)" for "(.*)"$/ do |not_see, high_or_low, image_filename, inventory_id|
  papyrus = Papyrus.find_by_inventory_id!(inventory_id)
  image = papyrus.images.find_by_image_file_name!(image_filename)

  link = find_or_nil("#download_#{high_or_low}_res_#{image.id}")
  if not_see
    link.should_not be
  else
    link.text.should eq "Download in #{high_or_low} resolution"
  end
end

When /^I follow "Download in (high|low) resolution" for "(.*)" for "(.*)"$/ do |high_or_low, image_filename, inventory_id|
  papyrus = Papyrus.find_by_inventory_id!(inventory_id)
  image = papyrus.images.find_by_image_file_name!(image_filename)

  link = find("#download_#{high_or_low}_res_#{image.id}")
  link.click
end

And /^"(.*)" uploaded image "(.*)" to "(.*)" with caption "(.*)"$/ do |email, image_filename, inventory_id, caption|
  papyrus = Papyrus.find_by_inventory_id!(inventory_id)
  upload(email, image_filename, papyrus, caption)
end

def upload(email, image_filename, papyrus, caption)
  login(email)
  visit new_papyrus_image_path(papyrus)
  attach_image(image_filename)
  fill_in("image_caption", :with => caption)
  click_button('Upload')
  logout
end

def attach_image(filename)
  attach_file('image_image', Rails.root.join('test_data', 'images', filename))
end

def find_or_nil(selector)
  begin
    find(selector)
  rescue Capybara::ElementNotFound
    nil
  end
end


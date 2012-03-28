When /^I attach image "(.*)"$/ do |filename|
  attach_image(filename)
end

And /^"(.*)" should have (\d+) image(s)?$/ do |inventory_id, num_images, _|
  Papyrus.find_by_inventory_id!(inventory_id).images.count.should eq num_images.to_i
end

And /^I should see papyrus image "(.*)"$/ do |image_name|
  page.should have_css(%Q{img[src*="#{image_name}"]})
end
Then /^I should (not )?see "(.*)" for "(.*)" for "(.*)"$/ do |not_see, link_text, image_filename, inventory_id|
  papyrus = Papyrus.find_by_inventory_id!(inventory_id)
  image = papyrus.images.find_by_image_file_name!(image_filename)

  link = find_or_nil("#download_high_res_#{image.id}")
  if not_see
    link.should_not be
  else
    link.text.should eq link_text
  end
end

When /^I follow "Download in high resolution" for "(.*)" for "(.*)"$/ do |image_filename, inventory_id|
  papyrus = Papyrus.find_by_inventory_id!(inventory_id)
  image = papyrus.images.find_by_image_file_name!(image_filename)

  link = find("#download_high_res_#{image.id}")
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


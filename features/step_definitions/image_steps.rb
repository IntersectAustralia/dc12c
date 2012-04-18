When /^I attach image "(.*)"$/ do |filename|
  attach_image(filename)
end

And /^"MQT (.*)" should have (\d+) image(s)?$/ do |mqt_number, num_images, _|
  Papyrus.find_by_mqt_number!(mqt_number).images.count.should eq num_images.to_i
end

And /^I should see (low_res|thumbnail) image for "(.*)" of papyrus "MQT (.*)"$/ do |image_type, image_name, mqt_number|
  papyrus = Papyrus.find_by_mqt_number!(mqt_number)
  image = papyrus.images.find_by_image_file_name!(image_name)
  page.should have_css(%Q{img[src*="/image/#{image.id}/#{image_type}"]})
end

Then /^I should (not )?see a thumbnail image for papyrus "MQT ([^"]*)"$/ do |not_see, mqt_number|
  papyrus = Papyrus.find_by_mqt_number!(mqt_number)
  begin
    if not_see
      find("#thumbnail_#{papyrus.id}").should_not be
    else
      find("#thumbnail_#{papyrus.id}").should be
    end
  rescue Capybara::ElementNotFound
    # ignore, this is expected
  end
end

Then /^I should (not )?see "Download in (high|low) resolution" for "(.*)" for "MQT (.*)"$/ do |not_see, high_or_low, image_filename, mqt_number|
  papyrus = Papyrus.find_by_mqt_number!(mqt_number)
  image = papyrus.images.find_by_image_file_name!(image_filename)

  link = find_or_nil("#download_#{high_or_low}_res_#{image.id}")
  if not_see
    link.should_not be
  else
    link.text.should eq "Download in #{high_or_low} resolution"
  end
end

When /^I follow "Download in (high|low) resolution" for "(.*)" for "MQT (.*)"$/ do |high_or_low, image_filename, mqt_number|
  papyrus = Papyrus.find_by_mqt_number!(mqt_number)
  image = papyrus.images.find_by_image_file_name!(image_filename)

  link = find("#download_#{high_or_low}_res_#{image.id}")
  link.click
end

And /^"(.*)" uploaded image "(.*)" to "MQT (.*)" with caption "(.*)"$/ do |email, image_filename, mqt_number, caption|
  papyrus = Papyrus.find_by_mqt_number!(mqt_number)
  upload(email, image_filename, papyrus, caption)
end

And /^"(.*)" uploaded images$/ do |email, table|
  user = User.find_by_email!(email)
  table.hashes.each do |row|
    papyrus = Papyrus.find_by_mqt_number(row['mqt'])
    upload(email, row['filename'], papyrus, row['caption'], row['ordering'])
  end
end

def upload(email, image_filename, papyrus, caption, ordering='')
  login(email)
  visit new_papyrus_image_path(papyrus)
  attach_image(image_filename)
  fill_in("image_caption", with: caption)
  fill_in("image_ordering", with: ordering)
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

Then /^I should see images ordered "(.*)" for mqt "(.*)"$/ do |filenames_cssv, mqt_number|
  papyrus = Papyrus.find_by_mqt_number!(mqt_number)
  expected_filenames = filenames_cssv.split(', ')

  found = page.all :css, 'img[src*="/low_res"]'

  actual_filenames_in_order = found.map do |elem|
    img_src = elem['src']
    image_id = /image\/(\d+)\/low_res/.match(img_src)[1]

    Image.find(image_id).image_file_name
  end

  actual_filenames_in_order.should eq expected_filenames
end

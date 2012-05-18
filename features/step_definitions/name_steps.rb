Then /^I fill in name information$/ do |table|
  table.rows_hash.each do |field_name, value|
    field = find("#name_#{field_name}")
    if field.tag_name == 'select'
      select value, from: field[:id]
    else
      field.set value
    end
  end
end
Then /^I should see names$/ do |table|
  name_hashes = all('.name_container').map do |name_container|
    %w(name role role_note added_information date).reduce({}) do |hash, field|
      hash.merge(field => name_container.find(".name_#{field}").text)
    end
  end
  name_hashes.should eq table.hashes
end

Given /^"MQT ([^"]*)" has names$/ do |mqt_number, table|
  papyrus = Papyrus.find_by_mqt_number! mqt_number
  table.hashes.each do |attrs|
    FactoryGirl.create(:name, attrs.merge(papyrus: papyrus))
  end
end

Given /^I follow edit for name "([^"]*)"$/ do |name|
  name = Name.find_by_name! name
  find("#edit_name_#{name.id}").click
end


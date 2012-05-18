Given /^I fill in connection information$/ do |table|
  table.rows_hash.each do |field_name, value|
    find("#connection_#{field_name}").set value
  end
end

Then /^I should see connections$/ do |table|
  connection_hashes = all('li.connection').map do |connection_container|
    mqt_text, description = connection_container.find('a').parent.text.split('- ', 2)
    number = mqt_text.split[-1]
    {
      'mqt' => number,
      'description' => description.chomp
    }
  end

  connection_hashes.should eq table.hashes
end

Given /^"MQT ([^"]*)" has connections$/ do |mqt_number, table|
  papyrus = Papyrus.find_by_mqt_number! mqt_number
  table.hashes.each do |attrs|
    mqt = attrs.delete('mqt')
    attrs['related_papyrus'] = Papyrus.find_by_mqt_number! mqt
    FactoryGirl.create(:connection, attrs.merge(papyrus: papyrus))
  end
end

Given /^I follow edit for connection "([^"]*)"$/ do |related_mqt|
  related_papyrus = Papyrus.find_by_mqt_number! related_mqt
  c = Connection.find_by_related_papyrus_id! related_papyrus
  find("#edit_connection_#{c.id}").click
end

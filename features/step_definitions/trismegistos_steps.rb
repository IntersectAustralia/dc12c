Then /the downloaded csv should look like/ do |table|
  page.response_headers['Content-Disposition'].should eq 'attachment; filename="trismegistos.csv"'

  CSV.parse(page.source).should eq table.raw
end

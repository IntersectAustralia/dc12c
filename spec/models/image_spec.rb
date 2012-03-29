require 'spec_helper'

describe Image do
  describe "associations" do
    it { should belong_to :papyrus }
  end
  it { should have_attached_file(:image) }
  describe "validations" do
    it { should validate_attachment_content_type(:image).allowing('image/tiff', 'image/png', 'image/gif', 'image/jpeg').rejecting('text/plain', 'text/xml') }
    it { should validate_attachment_size(:image).greater_than(1.byte).less_than(200.megabytes) }
    it { should validate_presence_of :papyrus_id }
    it { should validate_presence_of :caption }
  end
end

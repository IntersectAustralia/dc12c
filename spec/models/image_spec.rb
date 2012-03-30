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

  describe "high res filename" do
    it "should return the extension" do
      image = Factory(:image, image_file_name: 'blah.tiff')
      image.high_res_filename.should eq "p.macq.#{image.id}.tiff"
    end
    it "handles multiple dots" do
      image = Factory(:image, image_file_name: 'blah.blah.tiff')
      image.high_res_filename.should eq "p.macq.#{image.id}.tiff"
    end
    it "handles no dots" do
      image = Factory(:image, image_file_name: 'nodotshere')
      image.high_res_filename.should eq "p.macq.#{image.id}.nodotshere"
    end
  end
end

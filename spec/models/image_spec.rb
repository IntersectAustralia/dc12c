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
  describe "low res filename" do
    before :each do
      @papyrus = Factory(:papyrus)
    end
    it "should return unchanged caption" do
      image = Factory(:image, image_file_name: 'blah.jpg', caption: 'hello123', papyrus: @papyrus)
    image.low_res_filename.should eq "#{@papyrus.id}-hello123-low.jpeg"
    end
    it "should return downcased caption" do
      image = Factory(:image, image_file_name: 'blah.jpg', caption: 'hElLo123', papyrus: @papyrus)
      image.low_res_filename.should eq "#{@papyrus.id}-hello123-low.jpeg"
    end
    it "should remove non-alphanumeric characters" do
      image = Factory(:image, image_file_name: 'blah.jpg', caption: "!hE+_)(*&^`~\rlL o1!@$%^23\n\t", papyrus: @papyrus)
      image.low_res_filename.should eq "#{@papyrus.id}-hello123-low.jpeg"
    end
  end
end

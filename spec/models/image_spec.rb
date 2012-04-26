require 'spec_helper'

describe Image do
  describe "associations" do
    it { should belong_to :papyrus }
  end

  describe "default scope" do
    it "should order by ordering with nulls last" do
      d = Factory(:image, ordering: 'd')
      b = Factory(:image, ordering: 'b')
      a = Factory(:image, ordering: 'a')
      blank = Factory(:image, ordering: nil)
      c = Factory(:image, ordering: 'c')

      Image.all.should eq [a, b, c, d, blank]
    end
  end

  it { should have_attached_file(:image) }

  describe "validations" do
    it { should validate_attachment_content_type(:image).allowing('image/tiff', 'image/png', 'image/gif', 'image/jpeg').rejecting('text/plain', 'text/xml') }
    it { should validate_attachment_size(:image).greater_than(1.byte).less_than(200.megabytes) }
    it { should validate_presence_of :papyrus_id }
    it { should validate_presence_of :caption }
    it { should ensure_length_of(:caption).is_at_most(255) }
    it { should ensure_length_of(:ordering).is_at_most(1) }
    describe "ordering" do
      it "checks ordering is in A-Z (after upcasing)" do
        ('a'..'z').each do |letter|
          Factory(:image, ordering: 'a').should be_valid
        end
      end
      it "checks numbers are invalid" do
        (0..9).each do |digit|
          FactoryGirl.build(:image, ordering: digit).should_not be_valid
        end
      end
    end
  end

  describe "upcasing ordering" do
    it "upcases before validation" do
      i = Factory(:image, ordering: 'a')
      i.save!

      i.ordering.should eq 'A'

      i.reload

      i.ordering.should eq 'A'
    end
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
    it "should be less than 50 characters total" do
      image = Factory(:image, image_file_name: 'a.jpg', caption: "a" * 50, papyrus: @papyrus)
      image.low_res_filename.length.should <= 50
    end
  end
end

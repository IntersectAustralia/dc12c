require 'spec_helper'

describe Collection do
  before :all do
    @old_url_options = ActionController::Base.default_url_options
    new_url_options = {host: 'localhost:3000'}
    ActionController::Base.default_url_options = new_url_options
  end
  after :all do
    ActionController::Base.default_url_options = @old_url_options
  end

  describe "Associations" do
    it { should have_and_belong_to_many :papyri }
  end
  describe "Validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :keywords }
    it { should ensure_length_of(:title).is_at_most(255) }
    it { should ensure_length_of(:description).is_at_most(512) }
    it { should ensure_length_of(:keywords).is_at_most(255) }
    it { should ensure_length_of(:temporal_coverage).is_at_most(255) }
    it { should ensure_length_of(:spatial_coverage).is_at_most(255) }
    it "should validate title is unique" do
      p = FactoryGirl.create(:papyrus)
      FactoryGirl.create(:collection, papyrus_ids: [p.id])
      should validate_uniqueness_of :title
    end
    it "should validate that at least one papyrus is selected" do
      c = Collection.new(title: 'Some Title', keywords: 'Some; Keywords', description: 'some desc')
      c.should_not be_valid

      c.papyrus_ids = [FactoryGirl.create(:papyrus).id]
      c.should be_valid
    end
  end
  it "should sort by title by default" do
    papyrus = FactoryGirl.create(:papyrus)
    FactoryGirl.create(:collection, title: 'b', papyrus_ids: [papyrus.id])
    FactoryGirl.create(:collection, title: 'c', papyrus_ids: [papyrus.id])
    FactoryGirl.create(:collection, title: 'D', papyrus_ids: [papyrus.id])
    FactoryGirl.create(:collection, title: 'A', papyrus_ids: [papyrus.id])

    Collection.pluck(:title).should eq %w(A b c D)
  end
  describe "rif-cs and OAI" do
    subject do
      @id = 234
      @updated_at = Time.utc(2012, 12, 7, 16, 3, 45)
      @created_at = Time.utc(2011, 11, 6, 15, 2, 44)
      @title = 'some_title'
      @description = 'some_description'
      @rifcs_email = 'some_email@example.com'
      @spatial_coverage = 'over here'
      @temporal_coverage = 'at this time'
      @keywords = 'First keyword; second  '

      APP_CONFIG['rifcs_collection_location_email'] = @rifcs_email
      @view_url = "http://localhost:3000/collections/#{@id}"

      papyrus = FactoryGirl.create(:papyrus)
      it = FactoryGirl.create(:collection, id: @id, updated_at: @updated_at, created_at: @created_at, title: @title, description: @description, spatial_coverage: @spatial_coverage, temporal_coverage: @temporal_coverage, keywords: @keywords, papyrus_ids: [papyrus.id])
      it.save!
      it
    end

    it { should respond_to :to_rif }

    specify { subject.collection_group.should eq "Macquarie University" }

    specify { subject.collection_key.should eq @view_url }

    it "should have a collection_originating_source method that is the root URL" do
      subject.collection_originating_source.should eq "http://localhost:3000/"
    end

    it "should have a collection_date_modified method that is the updated_at field" do
      subject.collection_date_modified.should eq '2012-12-07T16:03:45Z'
    end

    it "should have a collection_date_accessioned method that is the created_at field" do
      subject.collection_date_accessioned.should eq '2011-11-06T15:02:44Z'
    end

    specify { subject.collection_type.should eq 'collection' }

    it "should have proper rights elements" do
      subject.collection_rights.should eq [
        {
          rights_statement: {
            value: 'Owned by the Museum of Ancient Cultures, Macquarie University.  Permission must be sought before publishing images of this collection.',
            rights_uri: 'http://localhost:3000/pages/legal'
          },
          access_rights: {
            value: 'Low resolution images are available via the website below for downloading.  Researchers may apply to Trevor Evans, the chair of the Macquarie Papyri R&D Committee to request access to high-resolution versions of the images. Please apply via the website or email shown below.  Physical access rights only by permission of the director of the Ancient Cultures Museum AND the chair of Macquarie Papyri R&D Committee.  Please Apply via the website or email shown below.',
            rights_uri: 'http://localhost:3000/pages/about'
          }
        }
      ]
    end
    it "should return the title in collection_names" do
      subject.collection_names.should eq [
        {
          xmllang: 'en',
          name_parts: [
            {
              value: @title,
              type: 'type'
            }
          ]
        }
      ]
    end
    it "should return the description in collection_descriptions" do
      subject.collection_descriptions.should eq [
        {
          value: @description + '<p>Temporal coverage: ' + @temporal_coverage + '</p>' ,
          type: 'full'
        }
      ]
    end
    it "should work with nils appropriately" do
      Collection.new(description: nil, temporal_coverage: nil).collection_descriptions
    end
    it "should return the collection_locations appropriately" do
      subject.collection_locations.should eq [
        {
          addresses: [
            {
              electronic: [
                {
                  type: 'email',
                  value: @rifcs_email
                },
                {
                  type: 'url',
                  value: @view_url
                }
              ],
              physical: [
                {
                  type: 'streetAddress',
                  address_parts: [
                    {
                      type: 'addressLine',
                      value: 'Building X5B Level 3<br /> Macquarie University<br /> NSW 2109<br /> Australia'
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    end
    pending "should have collection_related_objects of the museum and trevor and malcolm and karl" do
      subject.collection_related_objects.should eq(
        {
          is_owned_by: [
            {
              key: 'http://nla.gov.au/nla.party-1460842'
            }
          ],
          is_managed_by: [
            {
              key: 'http://nla.gov.au/nla.party-549541'
            }
          ]
        }
      )
    end
    it "should split the keywords by semi-colons and include static FOR codes" do
      keyword_hashes = subject.keywords.split(';').map do |keyword|
        { value: keyword.strip, type: 'local' }
      end

      subject.collection_subjects.should eq [
        { value: '210105', type: 'anzsrc-for'},
        { value: '200305', type: 'anzsrc-for'},
        { value: '210306', type: 'anzsrc-for'},
        *keyword_hashes
      ]
    end
    it "should report the coverage as in the model" do
      subject.collection_coverage.should eq [
        {
          spatials: [
            {
              value: @spatial_coverage,
              type: 'text'
            }
          ],
          temporals: [
            {
              dates: [],
              text: [@temporal_coverage]
            }
          ]
        }
      ]
    end
    it "should have sets of the right format" do
      sets = subject.sets
      sets.count.should eq 1

      set = sets.first
      set.name.should eq 'Collections'
      set.spec.should eq 'class:collection'
    end
    specify { subject.oai_dc_identifier.should eq @view_url }
    specify { subject.oai_dc_title.should eq @title }
    specify { subject.oai_dc_description.should eq @description }
  end
end

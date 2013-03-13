class Collection < ActiveRecord::Base
  include RIFCS::Collection

  FOR_CODES= ['210105', '200305', '210306']
  DATE_FORMAT = '%Y-%m-%dT%H:%M:%SZ'

  attr_accessible :title, :description, :keywords, :papyrus_ids, :spatial_coverage, :temporal_coverage
  has_and_belongs_to_many :papyri

  validates_presence_of :title
  validates_uniqueness_of :title

  validates_presence_of :description
  validates_presence_of :keywords

  validates_length_of :title, maximum: 255
  validates_length_of :keywords, maximum: 255
  validates_length_of :spatial_coverage, maximum: 255
  validates_length_of :temporal_coverage, maximum: 255
  default_scope order: 'lower(title)'

  validate :at_least_one_papyrus_selected

# required by RIFCS::Collection
  def collection_group
    "Macquarie University"
  end
  def collection_key
    view_url
  end
  def collection_originating_source
    url_opts = ActionController::Base.default_url_options
    Rails.application.routes.url_helpers.root_url(url_opts)
  end

  def collection_date_modified
    updated_at.strftime(DATE_FORMAT)
  end
  def collection_date_accessioned
    created_at.strftime(DATE_FORMAT)
  end

  def collection_type
    'collection'
  end

  def collection_rights
    [
      {
        rights_statement: {
          value: 'Owned by the Museum of Ancient Cultures, Macquarie University.  Permission must be sought before publishing images of this collection.',
          rights_uri: collection_originating_source + 'pages/legal'
        },
        access_rights: {
          value: 'Low resolution images are available via the website below for downloading.  Researchers may apply to Trevor Evans, the chair of the Macquarie Papyri R&D Committee to request access to high-resolution versions of the images. Please apply via the website or email shown below.  Physical access rights only by permission of the director of the Ancient Cultures Museum AND the chair of Macquarie Papyri R&D Committee.  Please Apply via the website or email shown below.',
          rights_uri: collection_originating_source + 'pages/about'
        }
      }
    ]
  end
  def collection_names
    [
      {
        xmllang: 'en',
        name_parts: [
          {
            value: title,
            type: 'type'
          }
        ]
      }
    ]
  end

  def collection_descriptions
    [
      {
        value: "#{description}<p>Temporal coverage: #{temporal_coverage}</p>",
        type: 'full'
      }
    ]
  end

  def collection_locations
    [
      {
        addresses: [
          {
            electronic: [
              {
                type: 'email',
                value: APP_CONFIG['rifcs_collection_location_email']
              },
              {
                type: 'url',
                value: view_url,
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
  def collection_related_objects
    {
      is_owned_by: ::Party.all.map { |party| { key:  party.oai_dc_identifier } },
      is_managed_by: ::Party.all.map { |party| { key:  party.oai_dc_identifier } },
    }
  end
  def collection_subjects
    for_codes = FOR_CODES.map do |code|
      {
        value: code,
        type: 'anzsrc-for'
      }
    end
    keywords = split_keywords.map do |keyword|
      {
        value: keyword,
        type: 'local'
      }
    end
    for_codes + keywords
  end

  def collection_coverage
    [
      {
        spatials: [
          {
            value: spatial_coverage,
            type: 'text'
          }
        ],
        temporals: [
          {
            dates: [
            ],
            text: [temporal_coverage]
          }
        ]
      }
    ]
  end
  def sets
    [
      OAI::Set.new({:name => 'Collections', :spec => 'class:collection'})
    ]
  end

  def oai_dc_identifier
    view_url
  end

  def oai_dc_title
    title
  end

  def oai_dc_description
    description
  end

  private

  def split_keywords
    keywords.split(';').map {|keyword| keyword.strip }
  end
  def view_url
    url_opts = ActionController::Base.default_url_options
    Rails.application.routes.url_helpers.collection_url(self, url_opts)
  end

  def at_least_one_papyrus_selected
    errors[:base] << "You must select at least one papyrus" unless papyrus_ids.length > 0
  end
end

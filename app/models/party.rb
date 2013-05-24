class Party < ActiveRecord::Base
  include RIFCS::Party

  attr_accessible :title, :given_name, :family_name, :email, :description, :homepage, :nla_identifier, :for_codes

  def oai_dc_identifier
    view_url
  end

  def oai_dc_title
    title
  end

  def oai_dc_description
    description
  end
  def party_originating_source
    url_opts = ActionController::Base.default_url_options
    Rails.application.routes.url_helpers.root_url(url_opts)
  end

  def party_group
    "Macquarie University"
  end
  def party_key
    view_url
  end
  def party_date_modified
    updated_at
  end
  def party_type
    'person'
  end
  def party_identifiers
    [   
      { value: "party-#{id}", type: 'local' },
      { value: nla_identifier, type: 'AU-ANL:PEAU' },
    ].select{|hsh| hsh[:value].present? }
  end

  def party_names
    # title component is now optional as it is only used for honorific such as Prof, Dr, etc.
    nameParts = []
    if !title.nil? and !title.empty?
      nameParts.append ({ type: 'title', value: title})
    end
    nameParts.append ({ type: 'given', value: given_name})
    nameParts.append ({ type: 'family', value: family_name})

    [   
      {   
        type: 'primary',
        name_parts: nameParts
      },  
    ]   
  end 

  def party_locations
    electronicAddress = [
        {
            type: 'email',
            value: email,
        }
    ]
    #Homepage is now an optional component
    if !homepage.nil? and !homepage.empty?
      electronicAddress.append (
          {
              type: 'uri',
              value: homepage,
          })
    end

    [
      {
        addresses: [
          {
            electronic: electronicAddress,
            physical: [
              {
                type: 'postalAddress',
                address_parts: [
                  {
                    type: 'text',
                    value: 'Building X5B Level 3<br /> Macquarie University<br /> NSW 2109<br /> Australia'
                  },
                ]
              },
              {
                address_parts: [
                  {
                    type: 'telephoneNumber',
                    value: '+61 2 9850 9263'
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  end

  def party_descriptions
    [
      {
        value: description,
        type: 'brief',
        'xml:lang' => 'en'
      },
    ]
  end

  def party_subjects
    for_codes.split(',').map do |code|
      {
        value: code,
        type: 'anzsrc-for'
      }
    end
  end

  private

  def view_url
    url_opts = ActionController::Base.default_url_options
    Rails.application.routes.url_helpers.party_url(self, url_opts)
  end
end

def create_roles_and_permissions
  Role.delete_all

  Role::ALL_ROLE_NAMES.each do |name|
    Role.new.tap {|r| r.name = name }.save!
  end
end

def create_languages
  language_names = %w{Greek Latin English Demotic}
  language_data = [
    ['Arabic', 'ara'],
    ['Aramaic', 'arc'],
    ['Egyptian\Coptic', 'cop'],
    ['Egyptian\Demotic', 'egy-Egyd'],
    ['Greek', 'grc'],
    ['Hebrew', 'heb'],
    ['Egyptian\Hieroglyphic', 'hig'],
    ['Egyptian\Hieratic', 'hir'],
    ['Nubian', 'nub'],
    ['Parthian', 'ira'],
    ['Italian', 'ita'],
    ['Latin', 'lat'],
    ['Middle Persian', 'pal'],
    ['Syriac', 'syr']
  ]
  Language.delete_all
  language_data.each do |name, code|
    Language.create! name: name, code: code
  end
end

def create_genres
  genre_names = ["Account",
                 "Contract",
                 "Document",
                 "Drawing",
                 "Fragment",
                 "Letter",
                 "List",
                 "Literary Text",
                 "Memorandum",
                 "Notification",
                 "Order",
                 "Petition",
                 "Receipt",
                 "Register",
                 "Report",
                 "Paraliterary",
                 "Survey",
                 "Tax receipt"
  ]
  Genre.delete_all
  genre_names.each do |name|
    Genre.create! name: name
  end
end

def create_parties
  party_hashes = [
    {
      title: 'Dr.',
      given_name: 'Trevor',
      family_name: 'Evans',
      email: 'trevor.evans@mq.edu.au',
      description: 'todo description',
      homepage: 'http://www.mq.edu.au/about_us/faculties_and_departments/faculty_of_arts/department_of_ancient_history/staff/dr_trevor_evans/',
      nla_identifier: 'http://nla.gov.au/nla.party-549541',
    },
    {
      title: 'Dr.',
      given_name: 'Malcolm',
      family_name: 'Choat',
      email: 'malcolm.choat@mq.edu.au',
      description: 'todo description',
      homepage: 'http://www.mq.edu.au/about_us/faculties_and_departments/faculty_of_arts/department_of_ancient_history/staff/dr_malcolm_choat/',
    },
    {
      title: 'Mr.',
      given_name: 'Karl',
      family_name: 'van Dyke',
      email: 'karl.vandyke@mq.edu.au',
      description: 'todo description',
      homepage: 'http://www.mac.mq.edu.au/',
    },
  ]
  party_hashes.each do |attrs|
    Party.create!(attrs)
  end
end

def create_roles_and_permissions
  Role.delete_all

  Role::ALL_ROLE_NAMES.each do |name|
    Role.new.tap {|r| r.name = name }.save!
  end
end

def create_languages
  language_names = %w{Greek Latin English Demotic}
  Language.delete_all
  language_names.each do |name|
    Language.create! name: name
  end
end

def create_genres
  genre_names = ["Account", "Contract", "Fragment", "Letter", "List", "Literary Text", "Memorandum", "Petition", "Receipt", "Report"]
  Genre.delete_all
  genre_names.each do |name|
    Genre.create! name: name
  end
end

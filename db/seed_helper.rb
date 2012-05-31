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
    ['Egyptian\Demotic', 'dem'],
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
  genre_names = ["Account", "Contract", "Document", "Drawing", "Fragment", "Letter", "List", "Literary Text", "Memorandum", "Petition", "Receipt", "Report", "Sub literary", "Survey", "Tax receipt"]
  Genre.delete_all
  genre_names.each do |name|
    Genre.create! name: name
  end
end

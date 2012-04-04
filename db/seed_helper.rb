def create_roles_and_permissions
  Role.delete_all
  Language.delete_all
  Country.delete_all
  Genre.delete_all

  create_countries %w{Greece Italy Australia}
  create_languages %w{Greek Latin English Demotic}
  create_genres %w{Book Fragment Scrap Painting}

  #TODO: create your roles here
  superuser = "Administrator"
  Role.create!(:name => superuser)

end

def create_countries country_names
  country_names.each do |name|
    Country.create! name: name
  end
end

def create_languages language_names
  language_names.each do |name|
    Language.create! name: name
  end
end

def create_genres genre_names
  genre_names.each do |name|
    Genre.create! name: name
  end
end

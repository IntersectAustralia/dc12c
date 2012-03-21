def create_roles_and_permissions
  Permission.delete_all
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

  #TODO: set your own permissions here
  create_permission("User", "read", [superuser])
  create_permission("User", "update_role", [superuser])
  create_permission("User", "activate_deactivate", [superuser])
  create_permission("User", "admin", [superuser])
  create_permission("User", "reject", [superuser])
  create_permission("User", "approve", [superuser])

  #TODO: create more permissions here
end

def create_permission(entity, action, roles)
  permission = Permission.new(:entity => entity, :action => action)
  permission.save!
  roles.each do |role_name|
    role = Role.where(:name => role_name).first
    role.permissions << permission
    role.save!
  end
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

require File.dirname(__FILE__) + '/sample_data_populator.rb'
require File.dirname(__FILE__) + '/fmp_import.rb'

def confirm?
  print "Are you sure you wish to continue? (Type 'yes' to continue.) "
  'yes' == STDIN.gets.chomp
end
begin  
  namespace :db do  
    desc "Populate the database with some sample data for testing"
    task :populate => :environment do  
      populate_data
    end
    desc "Import data from filemaker pro - overwrites existing papyri"
    task :import_fmp, [:filename, :image_root] => :environment do |task, args|
      filename = args.filename
      image_root = args.image_root
      raise 'usage: rake "db:import_fmp[csv_filename, image_root]"' unless filename.present? && image_root.present?
      puts "This will delete all your data before importing"
      if confirm?
        import_from_filemaker_pro filename, image_root
      else
        puts "exiting"
      end
    end
  end  

  desc "Create a superuser"
  task :create_superuser, [:first_name, :last_name, :email, :password] => :environment do |task, args|
    first_name = args.first_name
    last_name = args.last_name
    email = args.email
    password = args.password

    raise 'usage: rake "create_superuser[First Name, Last Name, email, password"' unless [first_name, last_name, email, password].all?(&:present?)
    create_superuser(first_name, last_name, email, password)
  end
rescue LoadError  
  puts "It looks like some Gems are missing: please run bundle install"  
end

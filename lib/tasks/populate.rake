require File.dirname(__FILE__) + '/sample_data_populator.rb'
require File.dirname(__FILE__) + '/fmp_import.rb'

def confirm?
  puts "Are you sure you wish to continue?"
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
      import_from_filemaker_pro args.filename, args.image_root
    end
  end  
rescue LoadError  
  puts "It looks like some Gems are missing: please run bundle install"  
end

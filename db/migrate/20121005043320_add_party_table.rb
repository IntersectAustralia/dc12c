class AddPartyTable < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.string :title, limit: 10
      t.string :given_name, limit: 50
      t.string :family_name, limit: 50
      t.string :email, limit: 100
      t.string :description, limit: 1000

      t.string :homepage, limit: 250
      t.string :nla_identifier, limit: 200

      t.timestamps
    end
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

end

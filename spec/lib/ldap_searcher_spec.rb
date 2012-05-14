require 'spec_helper'

describe LdapSearcher do
  before :all do
    @server = make_ldap_server
    @server.start
  end

  after :all do
    @server.stop
  end

  let(:carlos) { make_sr 'Carlos', 'Aya', 'mqx803999' }
  let(:ryan) { make_sr 'Ryan', 'Braganza', 'mqx804005' }
  let(:ryan2) { make_sr 'Ryan2', 'Braganza', 'mqx804006' }
  let(:malcolm) { make_sr 'Malcolm', 'Choat', 'mq31095291' }
  let(:grant) { make_sr 'Grant', 'Sayer', 'mq20101139' }
  let(:vladimir) { make_sr 'Vladimir', 'Markovic', 'mq20112255' }
  let(:some_student) {make_sr 'Some', 'Body', '41231211', 'some.body@students.mq.edu.au' }

  describe "search" do
    it "raises an exception if no search terms are given" do
      excluded_one_ids = []

      # treating nil and empty string the same way
      lambda { LdapSearcher.search(first_name: nil, last_name: '', one_id: '', excluded_one_ids: []) }.should raise_error

      LdapSearcher.search(first_name: 'a') # should_not raise_error
      LdapSearcher.search(last_name: 'a') # should_not raise_error
      LdapSearcher.search(one_id: 'a') # should_not raise_error
    end
    it "orders results by last name, first name" do
      search_results = LdapSearcher.search(first_name: 'a')
      search_results.should eq [carlos, ryan, ryan2, malcolm, vladimir, grant] # Aya, Braganza, Braganza, Choat, Markovic, Sayer
    end
    it "searches by 'contains' for first and last name" do
      LdapSearcher.search(first_name: 'dimi').should eq [vladimir]
      LdapSearcher.search(last_name: 'aye').should eq [grant]
    end
    it "searches by 'equals' for one_id" do
      LdapSearcher.search(one_id: '8').should eq []
      LdapSearcher.search(one_id: 'mqx803999').should eq [carlos]
    end
    it "searches multiple OUs, Students, Staff, Affiliated-Staff" do
      LdapSearcher.search(first_name: 'Some').should eq [some_student]
      LdapSearcher.search(first_name: 'Vladimir').should eq [vladimir]
      LdapSearcher.search(first_name: 'Carlos').should eq [carlos]
    end
    it "works for affiliated - mqxXXXXXX" do
      LdapSearcher.search(one_id: 'mqx804005').should eq [ryan]
    end
    it "works for staff      - mqXXXXXXXX" do
      LdapSearcher.search(one_id: 'mq31095291').should eq [malcolm]
    end
    it "works for students   - XXXXXXXX" do
      LdapSearcher.search(one_id: '41231211').should eq [some_student]
    end
    it "doesn't search other OUs" do
      # decoy is in OU=Decoy
      LdapSearcher.search(first_name: 'decoy').should eq []
    end
    it "ANDs search terms together" do
      LdapSearcher.search(first_name: 'Ryan', last_name: 'Braganza', one_id: 'mqx804005').should eq [ryan]
      LdapSearcher.search(first_name: 'Bryan', last_name: 'Braganza', one_id: 'mqx804005').should eq []
    end
    it "is case-insensitive" do
      LdapSearcher.search(first_name: 'R').should eq LdapSearcher.search(first_name: 'r')
    end
    it "ignores records with missing required attributes" do
      LdapSearcher.search(first_name: 'Nomail').should eq []
    end
    it "filters the supplied one_ids" do
      LdapSearcher.search(first_name: 'Ryan2').should eq [ryan2]
      LdapSearcher.search(first_name: 'Ryan2', excluded_one_ids: ['mqx804006']).should eq []
    end
    it "searches blank strings properly" do
      LdapSearcher.search(first_name: '', last_name: 'Braganza')
    end
  end
end

def make_sr(first_name, last_name, one_id, email=nil)
  email = "#{first_name.downcase}.#{last_name.downcase}@mq.edu.au" unless email
  {
    first_name: first_name,
    last_name: last_name,
    one_id: one_id,
    email: email
  }
end

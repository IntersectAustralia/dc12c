require 'spec_helper'

describe User do
  describe "Associations" do
    it { should belong_to(:role) }
  end

  describe "Named Scopes" do
    describe "Approved Users Scope" do
      it "should return users that are approved ordered by email address" do
        u1 = FactoryGirl.create(:user, :status => 'A', :email => "fasdf1@intersect.org.au")
        u2 = FactoryGirl.create(:user, :status => 'U')
        u3 = FactoryGirl.create(:user, :status => 'A', :email => "asdf1@intersect.org.au")
        u4 = FactoryGirl.create(:user, :status => 'R')
        u5 = FactoryGirl.create(:user, :status => 'D')
        User.approved.should eq([u3,u1])
      end
    end
    describe "Deactivated or Approved Users Scope" do
      it "should return users that are approved ordered by email address" do
        u1 = FactoryGirl.create(:user, :status => 'A', :email => "fasdf1@intersect.org.au")
        u2 = FactoryGirl.create(:user, :status => 'U')
        u3 = FactoryGirl.create(:user, :status => 'A', :email => "asdf1@intersect.org.au")
        u4 = FactoryGirl.create(:user, :status => 'R')
        u5 = FactoryGirl.create(:user, :status => 'D', :email => "zz@inter.org")
        User.deactivated_or_approved.should eq([u3,u1, u5])
      end
    end
    describe "Approved Administrators Scope" do
      it "should return users that are approved ordered by email address" do
        super_role = FactoryGirl.create(:role, :name => "Administrator")
        other_role = FactoryGirl.create(:role, :name => "Other")
        u1 = FactoryGirl.create(:user, :status => 'A', :role => super_role, :email => "fasdf1@intersect.org.au")
        u2 = FactoryGirl.create(:user, :status => 'A', :role => other_role)
        u3 = FactoryGirl.create(:user, :status => 'U', :role => super_role)
        u4 = FactoryGirl.create(:user, :status => 'R', :role => super_role)
        u5 = FactoryGirl.create(:user, :status => 'D', :role => super_role)
        User.approved_superusers.should eq([u1])
      end
    end
  end

  describe "Status Methods" do
    context "Active" do
      it "should be active" do
        user = FactoryGirl.create(:user, :status => 'A')
        user.approved?.should be_true
      end
    end

    context "Unapproved" do
      it "should not be active" do
        user = FactoryGirl.create(:user, :status => 'U')
        user.approved?.should be_false
      end
    end

    context "Rejected" do
      it "should not be active" do
        user = FactoryGirl.create(:user, :status => 'R')
        user.approved?.should be_false
      end
    end
  end

  describe "Update password" do
    it "should fail if current password is incorrect" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "asdf", :password => "Pass.456", :password_confirmation => "Pass.456"})
      result.should be_false
      user.errors[:current_password].should eq ["is invalid"]
    end
    it "should fail if current password is blank" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "", :password => "Pass.456", :password_confirmation => "Pass.456"})
      result.should be_false
      user.errors[:current_password].should eq ["can't be blank"]
    end
    it "should fail if new password and confirmation blank" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "", :password_confirmation => ""})
      result.should be_false
      user.errors[:password].should eq ["can't be blank", "must be between 6 and 20 characters long and contain at least one uppercase letter, one lowercase letter, one digit and one symbol"]
    end
    it "should fail if confirmation blank" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass.456", :password_confirmation => ""})
      result.should be_false
      user.errors[:password].should eq ["doesn't match confirmation"]
    end
    it "should fail if confirmation doesn't match new password" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass.456", :password_confirmation => "Pass.678"})
      result.should be_false
      user.errors[:password].should eq ["doesn't match confirmation"]
    end
    it "should fail if password doesn't meet rules" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass4567", :password_confirmation => "Pass4567"})
      result.should be_false
      user.errors[:password].should eq ["must be between 6 and 20 characters long and contain at least one uppercase letter, one lowercase letter, one digit and one symbol"]
    end
    it "should succeed if current password correct and new password ok" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass.456", :password_confirmation => "Pass.456"})
      result.should be_true
    end
    it "should always blank out passwords" do
      user = FactoryGirl.create(:user, :password => "Pass.123")
      result = user.update_password({:current_password => "Pass.123", :password => "Pass.456", :password_confirmation => "Pass.456"})
      user.password.should be_blank
      user.password_confirmation.should be_blank
    end
  end
  
  describe "Find the number of superusers method" do
    it "should return true if there are at least 2 superusers" do
      super_role = FactoryGirl.create(:role, :name => 'Administrator')
      user_1 = FactoryGirl.create(:user, :role => super_role, :status => 'A', :email => 'user1@intersect.org.au')
      user_2 = FactoryGirl.create(:user, :role => super_role, :status => 'A', :email => 'user2@intersect.org.au')
      user_3 = FactoryGirl.create(:user, :role => super_role, :status => 'A', :email => 'user3@intersect.org.au')
      user_1.check_number_of_superusers(1, 1).should eq(true)
    end

    it "should return false if there is only 1 superuser" do
      super_role = FactoryGirl.create(:role, :name => 'Administrator')
      user_1 = FactoryGirl.create(:user, :role => super_role, :status => 'A', :email => 'user1@intersect.org.au')
      user_1.check_number_of_superusers(1, 1).should eq(false)
    end
    
    it "should return true if the logged in user does not match the user record being modified" do  
      super_role = FactoryGirl.create(:role, :name => 'Administrator')
      research_role = FactoryGirl.create(:role, :name => 'Researcher')
      user_1 = FactoryGirl.create(:user, :role => super_role, :status => 'A', :email => 'user1@intersect.org.au')
      user_2 = FactoryGirl.create(:user, :role => research_role, :status => 'A', :email => 'user2@intersect.org.au')
      user_1.check_number_of_superusers(1, 2).should eq(true)
    end
  end

  describe "Validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :login_attribute }

    it "should validate presence of is_ldap" do
      FactoryGirl.build(:user, is_ldap: nil).should_not be_valid
      FactoryGirl.build(:user, is_ldap: true, one_id: 'mqxsomething', login_attribute: 'mqxsomething').should be_valid
      FactoryGirl.build(:user, is_ldap: false, email: 'a@a.com', login_attribute: 'a@a.com').should be_valid
    end
    it "should validate one_id is present if is_ldap" do
      FactoryGirl.build(:user, is_ldap: true, one_id: nil).should_not be_valid
      FactoryGirl.build(:user, is_ldap: true, one_id: 'something').should be_valid
    end
    it "should validate presence of dn is is_ldap"
    it "should validate uniqueness of dn, one_id"
    it "should validate login_attribute is equal to one_id or email" do
      FactoryGirl.build(:user, is_ldap: true, one_id: 'mqxsomething', email: 'a@a.com', login_attribute: 'a@a.com').should_not be_valid
      FactoryGirl.build(:user, is_ldap: true, one_id: 'mqxsomething', email: 'a@a.com', login_attribute: 'mqxsomething').should be_valid

      FactoryGirl.build(:user, is_ldap: false, one_id: 'mqxsomething', email: 'a@a.com', login_attribute: 'mqxsomething').should_not be_valid
      FactoryGirl.build(:user, is_ldap: false, one_id: 'mqxsomething', email: 'a@a.com', login_attribute: 'a@a.com').should be_valid
    end

    #password rules: at least one lowercase, uppercase, number, symbol
    # too short < 6
    it { should_not allow_value("AB$9a").for(:password) }
    # too long > 20
    it { should_not allow_value("Aa0$56789012345678901").for(:password) }
    # missing upper
    it { should_not allow_value("aaa000$$$").for(:password) }
    # missing lower
    it { should_not allow_value("AAA000$$$").for(:password) }
    # missing digit
    it { should_not allow_value("AAAaaa$$$").for(:password) }
    # missing symbol
    it { should_not allow_value("AAA000aaa").for(:password) }
    # ok
    it { should allow_value("AB$9aa").for(:password) }

    # check each of the possible symbols we allow
    it { should allow_value("AAAaaa000!").for(:password) }
    it { should allow_value("AAAaaa000@").for(:password) }
    it { should allow_value("AAAaaa000#").for(:password) }
    it { should allow_value("AAAaaa000$").for(:password) }
    it { should allow_value("AAAaaa000%").for(:password) }
    it { should allow_value("AAAaaa000^").for(:password) }
    it { should allow_value("AAAaaa000&").for(:password) }
    it { should allow_value("AAAaaa000*").for(:password) }
    it { should allow_value("AAAaaa000(").for(:password) }
    it { should allow_value("AAAaaa000)").for(:password) }
    it { should allow_value("AAAaaa000-").for(:password) }
    it { should allow_value("AAAaaa000_").for(:password) }
    it { should allow_value("AAAaaa000+").for(:password) }
    it { should allow_value("AAAaaa000=").for(:password) }
    it { should allow_value("AAAaaa000{").for(:password) }
    it { should allow_value("AAAaaa000}").for(:password) }
    it { should allow_value("AAAaaa000[").for(:password) }
    it { should allow_value("AAAaaa000]").for(:password) }
    it { should allow_value("AAAaaa000|").for(:password) }
    it { should allow_value("AAAaaa000\\").for(:password) }
    it { should allow_value("AAAaaa000;").for(:password) }
    it { should allow_value("AAAaaa000:").for(:password) }
    it { should allow_value("AAAaaa000'").for(:password) }
    it { should allow_value("AAAaaa000\"").for(:password) }
    it { should allow_value("AAAaaa000<").for(:password) }
    it { should allow_value("AAAaaa000>").for(:password) }
    it { should allow_value("AAAaaa000,").for(:password) }
    it { should allow_value("AAAaaa000.").for(:password) }
    it { should allow_value("AAAaaa000?").for(:password) }
    it { should allow_value("AAAaaa000/").for(:password) }
    it { should allow_value("AAAaaa000~").for(:password) }
    it { should allow_value("AAAaaa000`").for(:password) }
  end

  describe "Get superuser emails" do
    it "should find all approved superusers and extract their email address" do
      super_role = FactoryGirl.create(:role, :name => "Administrator")
      admin_role = FactoryGirl.create(:role, :name => "Admin")
      super_1 = FactoryGirl.create(:user, :role => super_role, :status => "A", :email => "a@intersect.org.au")
      super_2 = FactoryGirl.create(:user, :role => super_role, :status => "U", :email => "b@intersect.org.au")
      super_3 = FactoryGirl.create(:user, :role => super_role, :status => "A", :email => "c@intersect.org.au")
      super_4 = FactoryGirl.create(:user, :role => super_role, :status => "D", :email => "d@intersect.org.au")
      super_5 = FactoryGirl.create(:user, :role => super_role, :status => "R", :email => "e@intersect.org.au")
      admin = FactoryGirl.create(:user, :role => admin_role, :status => "A", :email => "f@intersect.org.au")

      supers = User.get_superuser_emails
      supers.should eq(["a@intersect.org.au", "c@intersect.org.au"])
    end
  end

  describe "Existing one_ids" do
    it "should return a list of all one ids that have already been created" do
      (1..4).each do |one_id|
        FactoryGirl.create(:user, one_id: one_id)
      end
      User.existing_one_ids.should eq ['1', '2', '3', '4']
    end
  end

  describe "assign_random_password" do
    it "sets a password that is valid" do
      u = FactoryGirl.build(:user)
      u.password = "Pass.123"
      u.save!

      u.assign_random_password
      u.password.should_not eq "Pass.123"

      u.save!
      u.reload
      u.password.should_not eq "Pass.123" # TODO it shouldn't, but it won't anyway as it is encrypted
    end
  end
  
end

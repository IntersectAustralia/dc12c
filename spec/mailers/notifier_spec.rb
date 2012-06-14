require "spec_helper"

describe Notifier do
  before :each do
    ActionMailer::Base.deliveries.clear
  end
  describe "Notification to superusers when access to papyrus requested" do
    it "should send the right email" do
      u = FactoryGirl.create(:user)
      p = FactoryGirl.create(:papyrus)
      super_role = FactoryGirl.create(:role, name: Role::SUPERUSER_ROLE_NAME)
      su = FactoryGirl.create(:user, role: super_role, status: "A")
      su2 = FactoryGirl.create(:user, role: super_role, status: "A")
      ar = FactoryGirl.create(:access_request, user: u, papyrus: p)
      Notifier.notify_superusers_of_papyrus_access_request(ar).deliver

      deliveries = ActionMailer::Base.deliveries
      deliveries.should_not be_empty
      email = deliveries[0]
      email.subject.should eq("Macquarie Papyri - Papyrus access request")
      email.to.should eq([su.email, su2.email])
      #user = FactoryGirl.create(:user, :status => "U", :email => ')
    end
  end

  describe "notify_user_of_account_creation" do
    it "has the correct information in it" do
      u = FactoryGirl.create(:user, first_name: 'First', last_name: 'Last', email: 'first.last@example.com', password: 'Pass.123')

      Notifier.notify_user_of_account_creation(u).deliver

      deliveries = ActionMailer::Base.deliveries
      deliveries.count.should eq 1
      email = deliveries[0]
      email.subject.should eq("Macquarie Papyri - Account Created")
      email.to.should eq [u.email]

      body = email.body
      body.should =~ /Login: first\.last@example\.com/
      body.should =~ /Password: Pass\.123/
      body.should =~ /#{Rails.application.routes.url_helpers.users_edit_password_path}/
    end
  end
 
end

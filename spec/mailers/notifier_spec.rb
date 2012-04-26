require "spec_helper"

describe Notifier do
  
  describe "Email notifications to users should be sent" do
    it "should send mail to user if access request approved" do
      address = 'user@email.org'
      user = FactoryGirl.create(:user, :status => "A", :email => address)
      email = Notifier.notify_user_of_approved_request(user).deliver
  
      # check that the email has been queued for sending
      ActionMailer::Base.deliveries.empty?.should eq(false) 
      email.to.should eq([address])
      email.subject.should eq("Papyri Data Capture - Your access request has been approved") 
    end

    it "should send mail to user if access request denied" do
      address = 'user@email.org'
      user = FactoryGirl.create(:user, :status => "A", :email => address)
      email = Notifier.notify_user_of_rejected_request(user).deliver
  
      # check that the email has been queued for sending
      ActionMailer::Base.deliveries.empty?.should eq(false) 
      email.to.should eq([address])
      email.subject.should eq("Papyri Data Capture - Your access request has been rejected") 
    end
  end

  describe "Notification to superusers when new access request created"
  it "should send the right email" do
    address = 'user@email.org'
    user = FactoryGirl.create(:user, :status => "U", :email => address)
    User.should_receive(:get_superuser_emails) { ["super1@intersect.org.au", "super2@intersect.org.au"] }
    email = Notifier.notify_superusers_of_access_request(user).deliver

    # check that the email has been queued for sending
    ActionMailer::Base.deliveries.empty?.should eq(false)
    email.subject.should eq("Papyri Data Capture - There has been a new access request")
    email.to.should eq(["super1@intersect.org.au", "super2@intersect.org.au"])
  end

  describe "Notification to superusers when access to papyrus requested"
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
    email.subject.should eq("Papyri Data Capture - Papyrus access request")
    email.to.should eq([su.email, su2.email])
    #user = FactoryGirl.create(:user, :status => "U", :email => ')
  end
 
end

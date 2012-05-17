require "spec_helper"

describe Notifier do
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

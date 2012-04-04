Feature: As an administrator
  I want to accept and reject
  requests from researchers to
  access papyrus records

Background:
  Given I have a user "admin@intersect.org.au" with role "Administrator"
  And I have a user "researcher@intersect.org.au" with role "Researcher"
  And I have languages
    | name     |
    | Greek    |
    | Coptic   |
    | Egyptian |
    | Demotic  |
    | Latin    |
  And I have countries
    | name   |
    | Greece |
    | Egypt  |
    | Cyprus |
    | Turkey |
  And I have a papyrus
    | inventory_id | languages       | width | height | date   | general_note  | note           | visibility | country_of_origin |
    | visible.macq | Coptic, Demotic | 60    | 177    | 488 CE | General stuff | Specific stuff | VISIBLE    | Turkey            |
  And I have an access request for "visible.macq" from "researcher@intersect.org.au"


Scenario: Admin can accept an access request
  Given I am logged in as "admin@intersect.org.au"
  And I am on the admin page
  And I follow "Pending requests"
  Then I should see "visible.macq"
  And I should see "researcher@intersect.org.au"
  When I follow "visible.macq"
  And I press "Approve"
  Then I should be on the list requests page
  And I should see "The request was approved"
  Then I am on the admin page
  And I follow "Approved requests"
  Then I should see "visible.macq"
  And I should see "researcher@intersect.org.au"

Scenario: Admin can reject an access request
  Given I am logged in as "admin@intersect.org.au"
  And I am on the admin page
  And I follow "Pending requests"
  Then I should see "visible.macq"
  And I should see "researcher@intersect.org.au"
  When I follow "visible.macq"
  And I press "Reject"
  Then I should be on the list requests page
  And I should see "The request was rejected"
  Then I am on the admin page
  And I follow "Approved requests"
  Then I should not see "visible.macq"
  And I should not see "researcher@intersect.org.au"
  Then I am on the admin page
  And I follow "Rejected requests"
  Then I should see "visible.macq"
  And I should see "researcher@intersect.org.au"


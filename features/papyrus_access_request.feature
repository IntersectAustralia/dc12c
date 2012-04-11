Feature: As an administrator
  I want to accept and reject
  requests from researchers to
  access papyrus records

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher1@intersect.org.au" with role "Researcher"
    And I have a user "researcher2@intersect.org.au" with role "Researcher"
    And I have a user "researcher3@intersect.org.au" with role "Researcher"
    And I have a user "researcher4@intersect.org.au" with role "Researcher"
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
    And I have papyrus access requests
      | Inventory ID | User requesting access       | Date requested | Date approved |
      | visible.macq | researcher1@intersect.org.au | 2010-05-02     | 2011-06-03    |
      | visible.macq | researcher2@intersect.org.au | 2010-05-02     | 2011-06-04    |
      | visible.macq | researcher3@intersect.org.au | 2010-05-02     | 2012-01-16    |
      | visible.macq | researcher4@intersect.org.au | 2010-05-02     | 2011-08-03    |


  Scenario: Admin can accept an access request
    Given I am logged in as "admin@intersect.org.au"
    And I am on the admin page
    When I follow "Pending requests"
    Then I should see pending requests
      | Inventory ID | User requesting access       | Date requested |
      | visible.macq | researcher1@intersect.org.au | 2010-05-02     |
      | visible.macq | researcher2@intersect.org.au | 2010-05-02     |
      | visible.macq | researcher3@intersect.org.au | 2010-05-02     |
      | visible.macq | researcher4@intersect.org.au | 2010-05-02     |

    When I follow "visible.macq"
    And the date is "2011-06-03"
    And I press "Approve"
    Then I should be on the list requests page
    And I should see "The request was approved"
    When I am on the admin page
    And I follow "Approved requests"
    Then I should see approved requests
      | Inventory ID | User with access             | Date requested | Date approved |
      | visible.macq | researcher1@intersect.org.au | 2010-05-02     | 2011-06-03    |

  Scenario: Admin can reject an access request
    Given I am logged in as "admin@intersect.org.au"
    And I am on the admin page
    And I follow "Pending requests"
    Then I should see pending requests
      | Inventory ID | User requesting access       | Date requested |
      | visible.macq | researcher1@intersect.org.au | 2010-05-02     |
      | visible.macq | researcher2@intersect.org.au | 2010-05-02     |
      | visible.macq | researcher3@intersect.org.au | 2010-05-02     |
      | visible.macq | researcher4@intersect.org.au | 2010-05-02     |
    When I follow "visible.macq"
    And I press "Reject"
    Then I should be on the list requests page
    And I should see "The request was rejected"

    When I am on the admin page
    And I follow "Approved requests"
    Then I should see approved requests
      | Inventory ID | User with access | Date requested |

    When I am on the admin page
    And I follow "Rejected requests"
    Then I should see rejected requests
      | Inventory ID | User requesting access       | Date requested |
      | visible.macq | researcher1@intersect.org.au | 2010-05-02     |

  Scenario: can press back on the list page and be at the admin page
    Given I am logged in as "admin@intersect.org.au"
    And I am on the list pending requests page
    When I follow "Back"
    Then I should be on the admin page

  @wip
  Scenario: approved requests has pagination and is sorted by most recent approved date
    Given I am logged in as "admin@intersect.org.au"
    And pagination for the approved requests page is set to "1"
    When I approve the requests
      | user_requesting_access       | date_approved |
      | researcher1@intersect.org.au | 2011-04-03    |
      | researcher2@intersect.org.au | 2011-06-03    |
      | researcher3@intersect.org.au | 2010-10-14    |
      | researcher4@intersect.org.au | 2011-01-20    |
    And I am on page 1 of the list approved requests index
    Then I should see approved requests
      | Inventory ID | User with access             | Date requested | Date approved |
      | visible.macq | researcher2@intersect.org.au | 2010-05-02     | 2011-06-03    |
    And I am on page 2 of the list approved requests index
    Then I should see approved requests
      | Inventory ID | User with access             | Date requested | Date approved |
      | visible.macq | researcher1@intersect.org.au | 2010-05-02     | 2011-04-03    |
    And I am on page 3 of the list approved requests index
    Then I should see approved requests
      | Inventory ID | User with access             | Date requested | Date approved |
      | visible.macq | researcher4@intersect.org.au | 2010-05-02     | 2011-01-20    |
    And I am on page 4 of the list approved requests index
    Then I should see approved requests
      | Inventory ID | User with access             | Date requested | Date approved |
      | visible.macq | researcher3@intersect.org.au | 2010-05-02     | 2010-10-14    |


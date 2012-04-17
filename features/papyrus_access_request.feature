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
    And I have a papyrus
      | mqt_number | inventory_id | languages       | dimensions | date_from | general_note  | lines_of_text  | visibility |
      | 5          | visible.macq | Coptic, Demotic | 5 x 6 cm   | 488 CE    | General stuff | Specific stuff | VISIBLE    |

    And I have papyrus access requests
      | MQT Number | User requesting access       | Date requested | Date approved |
      | 5          | researcher1@intersect.org.au | 2010-05-02     |               |
      | 5          | researcher2@intersect.org.au | 2010-02-02     |               |
      | 5          | researcher3@intersect.org.au | 2010-05-03     |               |
      | 5          | researcher4@intersect.org.au | 2009-05-02     |               |


  Scenario: Admin can accept an access request
    Given I am logged in as "admin@intersect.org.au"
    And I am on the admin page
    When I follow "Pending requests"
    Then I should see pending requests
      | MQT Number | Inventory ID | User requesting access       | Date requested |
      | MQT 5      | visible.macq | researcher4@intersect.org.au | 2009-05-02     |
      | MQT 5      | visible.macq | researcher2@intersect.org.au | 2010-02-02     |
      | MQT 5      | visible.macq | researcher1@intersect.org.au | 2010-05-02     |
      | MQT 5      | visible.macq | researcher3@intersect.org.au | 2010-05-03     |

    When I follow "MQT 5"
    And the date is "2011-06-03"
    Then I should see "MQT 5"
    And I should see "488 CE"
    And I should see "Fred Bloggs is requesting access to this record"
    When I press "Approve"
    Then I should be on the list pending requests page
    And I should see "The request was approved"
    When I am on the admin page
    And I follow "Approved requests"
    Then I should see approved requests
      | MQT Number | Inventory ID | User with access             | Date requested | Date approved |
      | MQT 5      | visible.macq | researcher4@intersect.org.au | 2009-05-02     | 2011-06-03    |

  Scenario: Admin can reject an access request
    Given I am logged in as "admin@intersect.org.au"
    And I am on the admin page
    And I follow "Pending requests"
    Then I should see pending requests
      | MQT Number | Inventory ID | User requesting access       | Date requested |
      | MQT 5      | visible.macq | researcher4@intersect.org.au | 2009-05-02     |
      | MQT 5      | visible.macq | researcher2@intersect.org.au | 2010-02-02     |
      | MQT 5      | visible.macq | researcher1@intersect.org.au | 2010-05-02     |
      | MQT 5      | visible.macq | researcher3@intersect.org.au | 2010-05-03     |
    When I follow "MQT 5"
    And I press "Reject"
    Then I should be on the list pending requests page
    And I should see "The request was rejected"

    When I am on the admin page
    And I follow "Approved requests"
    Then I should see approved requests
      | Inventory ID | User with access | Date requested |

  Scenario: can press back on the list page and be at the admin page
    Given I am logged in as "admin@intersect.org.au"
    And I am on the list pending requests page
    When I follow "Back"
    Then I should be on the admin page

  @papyrus_per_page_is_one
  Scenario: approved requests has pagination and is sorted by most recent approved date
    Given I am logged in as "admin@intersect.org.au"
    When I approve the requests
      | user_requesting_access       | date_approved |
      | researcher1@intersect.org.au | 2011-04-03    |
      | researcher2@intersect.org.au | 2011-06-03    |
      | researcher3@intersect.org.au | 2010-10-14    |
      | researcher4@intersect.org.au | 2011-01-20    |
    And I am on page 1 of the list approved requests index
    Then I should see approved requests
      | MQT Number | Inventory ID | User with access             | Date requested | Date approved |
      | MQT 5      | visible.macq | researcher2@intersect.org.au | 2010-02-02     | 2011-06-03    |
    And I am on page 2 of the list approved requests index
    Then I should see approved requests
      | MQT Number | Inventory ID | User with access             | Date requested | Date approved |
      | MQT 5      | visible.macq | researcher1@intersect.org.au | 2010-05-02     | 2011-04-03    |
    And I am on page 3 of the list approved requests index
    Then I should see approved requests
      | MQT Number | Inventory ID | User with access             | Date requested | Date approved |
      | MQT 5      | visible.macq | researcher4@intersect.org.au | 2009-05-02     | 2011-01-20    |
    And I am on page 4 of the list approved requests index
    Then I should see approved requests
      | MQT Number | Inventory ID | User with access             | Date requested | Date approved |
      | MQT 5      | visible.macq | researcher3@intersect.org.au | 2010-05-03     | 2010-10-14    |

  Scenario: approve/reject page has a cancel button
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    And I follow "Pending requests"
    When I follow "MQT 5"
    And I follow "Cancel"
    Then I should be on the list pending requests page

    @wip
  Scenario: admin can revoke a access request
    Given I am logged in as "admin@intersect.org.au"
    When I approve the requests
      | user_requesting_access       | date_approved |
      | researcher1@intersect.org.au | 2011-04-03    |
    Then I am on the admin page
    And I follow "Approved requests"
    When I follow "MQT 5"
    Then show me the page
    Then I should be on the revoke access request page
    And I follow "Revoke Access"
    Then I should be on the list approved requests page
    And I should see "The user's access to this record has been revoked."


Feature: In order to describe related papyri
  As an administrator
  I want to manage connection

  As a user
  I want to view connections

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"
    And I have papyri
      | mqt_number | visibility |
      | 3          | VISIBLE    |
      | 4          | PUBLIC     |
      | 5          | VISIBLE    |
      | 6          | HIDDEN     |
    And I have languages
      | name     |
      | Greek    |
      | Coptic   |
      | Egyptian |
      | Demotic  |
      | Latin    |
    And I have genres
      | name          |
      | Letter        |
      | Book          |
      | Book Fragment |

  Scenario: add a connection
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 3" papyrus page
    And I follow "Add Connection"
    And I fill in connection information
      | mqt         | 4     |
      | description | desc  |
    And I press "Save"
    Then I should be on the "MQT 3" papyrus page
    And I should see "The connection was successfully created."
    And I should see connections
      | mqt | description |
      | 4   | desc        |

  Scenario: add a connection fail
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 3" papyrus page
    And I follow "Add Connection"
    And I fill in connection information
      | mqt         | 10             |
      | description | does not exist |
    And I press "Save"
    And I should see "The record could not be saved"
    
  Scenario: check ordering
    Given "MQT 3" has connections
      | mqt | description |
      | 4   | f           |
      | 6   | a           |
      | 5   | d           |
    And I am logged in as "admin@intersect.org.au"
    When I am on the "MQT 3" papyrus page
    Then I should see connections
      | mqt | description |
      | 6   | a           |
      | 5   | d           |
      | 4   | f           |

  Scenario: edit a connection
    Given "MQT 3" has connections
      | mqt | description |
      | 4   | f           |
    And I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 3" papyrus page
    And I follow edit for connection "4"
    And I fill in connection information
      | mqt         | 5         |
      | description | sth       |
    And I press "Save"
    Then I should be on the "MQT 3" papyrus page
    And I should see connections
      | mqt | description |
      | 5   | sth         |
    And I should see "The connection was successfully updated."

  Scenario: failing edit
    Given "MQT 3" has connections
      | mqt | description |
      | 5   | something   |
    And I am logged in as "admin@intersect.org.au"
    And I am on the edit connection page for "5" for papyrus "MQT 3"
    And I fill in connection information
      | mqt | |
    And I press "Save"
    Then I should see "The record could not be saved"

  Scenario: destroy a connection
    Given "MQT 3" has connections
      | mqt | description |
      | 5   | something   |
    And I am logged in as "admin@intersect.org.au"
    And I am on the edit connection page for "5" for papyrus "MQT 3"
    When I press "Delete"
# and i confirm the popup
    Then I should see "The connection was deleted."
    And I should be on the "MQT 3" papyrus page
    And I should see connections
      | mqt | description |

  Scenario: researcher can't add or edit
    Given "MQT 3" has connections
      | mqt | description |
      | 5   | something   |
    And I am logged in as "researcher@intersect.org.au"
    When I am on the "MQT 3" papyrus page
    Then I should not see "Add Connection"
    When I am on the edit connection page for "5" for papyrus "MQT 3"
    Then I should be on the home page
    And I should see "You are not authorized to access this page."

  Scenario: anonymous can't add or edit
    Given "MQT 3" has connections
      | mqt | description |
      | 5   | something   |
    When I am on the "MQT 3" papyrus page
    Then I should not see "Add Connection"
    When I am on the edit connection page for "5" for papyrus "MQT 3"
    Then I should be on the home page
    And I should see "You are not authorized to access this page."

  Scenario: check researcher visibility
    Given "MQT 3" has connections
      | mqt | description |
      | 4   | public      |
      | 5   | visible     |
      | 6   | hidden      |
    And I am logged in as "researcher@intersect.org.au"
    When I am on the "MQT 3" papyrus page
    Then I should see connections
      | mqt | description |
      | 6   | hidden      |
      | 4   | public      |
      | 5   | visible     |

  Scenario: check anonymous visibility
    Given "MQT 3" has connections
      | mqt | description |
      | 4   | public      |
      | 5   | visible     |
      | 6   | hidden      |
    When I am on the "MQT 3" papyrus page
    Then I should see connections
      | mqt | description |
      | 4   | public      |
      | 5   | visible     |

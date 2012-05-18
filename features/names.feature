Feature: In order to describe related names of papyri
  As an administrator
  I want to manage names

  As a user
  I want to view names

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"
    And I have a papyrus
      | mqt_number | visibility |
      | 9          | VISIBLE    |
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

  Scenario: add a name
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 9" papyrus page
    And I follow "Add Name"
    And I fill in name information
      | name     | jake  |
      | ordering | B     |
    And I press "Save"
    Then I should be on the "MQT 9" papyrus page
    And I should see "The name was successfully created."
    And I should see names
      | name | role | role_note | added_information | date |
      | jake |      |           |                   |      |
    
  Scenario: check ordering
    Given "MQT 9" has names
      | name | ordering |
      | jake | D        |
      | alex | A        |
      | ibi  | C        |
    When I am on the "MQT 9" papyrus page
    Then I should see names
      | name | role | role_note | added_information | date |
      | alex |      |           |                   |      |
      | ibi  |      |           |                   |      |
      | jake |      |           |                   |      |

  Scenario: edit a name
    Given "MQT 9" has names
      | name | role | role_note | added_information | date |
      | jake | AUT  | an author | way cool          | 2012 |
    And I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 9" papyrus page
    And I follow edit for name "jake"
    And I fill in name information
      | name              | ryan      |
      | role              | Associate |
      | role_note         | asso      |
      | added_information | okay      |
      | date              | 2013      |
    And I press "Save"
    Then I should be on the "MQT 9" papyrus page
    And I should see names
      | name | role      | role_note | added_information | date |
      | ryan | Associate | asso      | okay              | 2013 |
    And I should see "The name was successfully updated."

  Scenario: failing edit
    Given "MQT 9" has names
      | name |
      | n    |
    And I am logged in as "admin@intersect.org.au"
    And I am on the edit name page for "n" for "MQT 9"
    And I fill in name information
      | name  |       |
    And I press "Save"
    Then I should see "The record could not be saved"

  Scenario: destroy a name
    Given "MQT 9" has names
      | name |
      | n    |
    And I am logged in as "admin@intersect.org.au"
    And I am on the edit name page for "n" for "MQT 9"
    When I press "Delete"
# and i confirm the popup
    Then I should see "The name was deleted."
    And I should be on the "MQT 9" papyrus page
    And I should see names
      | name | role | role_note | added_information | date |

  Scenario: researcher can't add or edit
    Given "MQT 9" has names
      | name |
      | n    |
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the "MQT 9" papyrus page
    Then I should not see "Add Name"
    And I am on the edit name page for "n" for "MQT 9"
    Then I should be on the home page
    And I should see "You are not authorized to access this page."

  Scenario: anonymous can't add or edit
    Given "MQT 9" has names
      | name |
      | n    |
    When I am on the "MQT 9" papyrus page
    Then I should not see "Add Name"
    And I am on the edit name page for "n" for "MQT 9"
    Then I should be on the home page
    And I should see "You are not authorized to access this page."

Feature: Collections
  In order to advertise my data
  As an admin,
  I want to manage collections

  In order to view data in order
  As a user,
  I want to view collections

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"
    And I have papyri
      | mqt_number | visibility |
      | 3          | PUBLIC     |
      | 4          | VISIBLE    |
      | 5          | HIDDEN     |
    And I have languages
      | name     |
      | Coptic   |
      | Demotic  |
      | Egyptian |
    And I have genres
      | name          |
      | Letter        |
      | Book          |
      | Book Fragment |
    And I have collections "MyCollection" with description "My description"
      | title             | description           | keywords | mqts    |
      | MyCollection      | My description.       | first    | 3, 4, 5 |
      | MyOtherCollection | My other description. | other    | 3, 4, 5 |

  @urlhack
  Scenario: View Collections anonymous
    Given I am on the home page
    And I follow "Collections"
    Then I should see collections
      | title             | description           |
      | MyCollection      | My description.       |
      | MyOtherCollection | My other description. |
    When I follow "MyOtherCollection"
    Then I should see collection
      | title             | description           | keywords | mqts |
      | MyOtherCollection | My other description. | other    | 3, 4 |

  @urlhack
  Scenario Outline: View Collections researcher/admin
    Given I am on the home page
    And I am logged in as "<user>@intersect.org.au"
    And I follow "Collections"
    Then I should see collections
      | title             | description           |
      | MyCollection      | My description.       |
      | MyOtherCollection | My other description. |
    When I follow "MyOtherCollection"
    Then I should see collection
      | title             | description           | keywords | mqts    |
      | MyOtherCollection | My other description. | other    | 3, 4, 5 |
    Examples:
      | user       |
      | researcher |
      | admin      |

  Scenario: Researcher/Anonymous can't create collection
    Given I am on the new collection page
    Then I should see "You are not authorized to access this page."

    Given I am logged in as "researcher@intersect.org.au"
    When I am on the new collection page
    Then I should see "You are not authorized to access this page."

  @urlhack
  Scenario: Admin creates collection
    Given I am logged in as "admin@intersect.org.au"
    And I am on the collections page
    And I follow "New Collection"
    And I fill in collection details
      | title | description | keywords | mqts |
      | ttle  | dcription   | kwords   | 3    |
    And I press "Save"
    Then I should see "The collection was successfully created."

    When I am on the collections page
    And I follow "ttle"
    Then I should see collection
      | title | description | keywords | mqts |
      | ttle  | dcription   | kwords   | 3    |

  @urlhack
  Scenario: Admin creates collection fail
    Given I am logged in as "admin@intersect.org.au"
    And I am on the new collection  page
    And I fill in collection details
      | title | description | keywords | mqts |
      |       | dcription   | kwords   | 3    |
    And I press "Save"
    Then I should see "The record could not be saved"

  @urlhack
  Scenario: Admin edits collection
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MyCollection" collection page
    When I follow "Edit"
    And I fill in "collection_title" with "New Title"
    And I press "Save"
    Then I should see "The collection was successfully updated."
    And I should see collection
      | title     | description     | keywords | mqts    |
      | New Title | My description. | first    | 3, 4, 5 |

  @urlhack
  Scenario: Admin edits collection fail
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MyCollection" collection page
    When I follow "Edit"
    And I fill in "collection_title" with ""
    And I press "Save"
    Then I should see "The record could not be saved"

  @urlhack
  Scenario: Researcher can't edit collection
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "MyCollection" collection page
    Then I should not see "Edit"

  @wip
  Scenario: XML checking

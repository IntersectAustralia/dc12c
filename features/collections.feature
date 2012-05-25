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

  Scenario: View Collections anonymous
    Given I am on the home page
    And I follow "Collections"
    Then I should see collections
      | title             | description           |
      | MyCollection      | My description.       |
      | MyOtherCollection | My other description. |
    When I follow "MyOtherCollection"
    Then I should see collection
      | title             | description           | keywords | mqts    |
      | MyOtherCollection | My other description. | other    | 3, 4, 5 |

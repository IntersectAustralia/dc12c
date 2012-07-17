Feature: OAI
  In order to provide an OAI-PMH interface to RDA
  As an anonymous user,
  I want there to be an OAI-PMH interface

  Background:
    Given I have papyri
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
      | title             | description           | keywords | spatial_coverage | temporal_coverage | mqts    |
      | MyCollection      | My description.       | first    | first spatial    | first temporal    | 3, 4, 5 |
      | MyOtherCollection | My other description. | other    | 2nd spatial      | 2nd temporal      | 3, 4, 5 |

  @urlhack
  Scenario: engine is mounted
    Given I am on the oai_repository page
    Then I should see "Value of the verb argument is not a legal OAI-PMH verb, the verb argument is missing, or the verb argument is repeated."

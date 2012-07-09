Feature: Advanced Searching With Dates
  As a user I want to Search by Dates
  so I can find the papyrus I am looking for

  Background:
    Given I have languages
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
    And I have papyri
      | mqt_number | date_from | date_to | visibility |
      | 1          | 1 CE      |         | VISIBLE    |
      | 2          |           |         | VISIBLE    |
      | 3          | 3 BCE     |         | VISIBLE    |
      | 4          | 1 BCE     | 1 CE    | VISIBLE    |
    And I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"

  Scenario Outline: Admin advanced search with dates
    Given I am logged in as "admin@intersect.org.au"
    And I am on the advanced search page
    And I fill in date search information "<date_from>" "<date_to>"
    And I press "Search"
    Then I should see search results "MQT <search_results>"
  Examples:
    | date_from | date_to | search_results |
    | 3 BCE     |         | 1, 3, 4        |
    | 1 BCE     |         | 1, 4           |
    | 1 CE      |         | 1, 4           |
    | 3 BCE     | 3 BCE   | 3              |
    | 1 BCE     | 1 BCE   | 4              |
    |           | 1 CE    | 1, 3, 4        |
    |           | 1 BCE   | 3, 4           |

  Scenario Outline: Admin advanced search with errors
    Given I am logged in as "admin@intersect.org.au"
    And I am on the advanced search page
    And I fill in date search information "<date_from>" "<date_to>"
    And I press "Search"
    Then I should see search errors "<search_error>"
  Examples:
    | date_from | date_to | search_error                                         |
    | 3         | 1       | Date From must have an era, Date To must have an era |
    | BCE       |         | Date From must have a year                           |
    | 0 BCE     |         | Date From must not be zero                           |
    | 0 CE      |         | Date From must not be zero                           |
    | 1 CE      | 1 BCE   | Date To must not be less than Date From              |

  @papyrus_per_page_is_one
  Scenario: Date information is retained after a search
    Given I am logged in as "admin@intersect.org.au"
    And I am on the advanced search page
    And I fill in date search information "1234 BCE" "432 CE"
    And I press "Search"
    Then I should see date search information "1234" "BCE" "432" "CE"

  @wip
  Scenario: researcher and anonymous tests

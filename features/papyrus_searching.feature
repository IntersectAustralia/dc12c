Feature: Searching Papyri
  As a user I want to
  Search so I can find the
  papyrus I am looking for

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
    And I have countries
      | name   |
      | Greece |
      | Egypt  |
      | Cyprus |
      | Turkey |
    And I have papyri
      | inventory_id | languages | general_note | note      | paleographic_description | recto_note | verso_note | country_of_origin | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary | original_text       | translated_text | visibility |
      | pmac20       | Greek     |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac21       |           | window wash  |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac22       |           |              | plant pot |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac23       |           |              |           | elephant                 |            |            |                   |                |                       |                   |       |               |         |                     |                 | HIDDEN     |
      | pmac24       |           |              |           |                          | front end  |            |                   |                |                       |                   |       |               |         |                     |                 | HIDDEN     |
      | pmac25       |           |              |           |                          |            | rear end   |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac26       |           |              |           |                          |            |            | Cyprus            |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac27       |           |              |           |                          |            |            |                   | very hot place |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac28       |           |              |           |                          |            |            |                   |                | brought from a shop   |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac29       |           |              |           |                          |            |            |                   |                |                       | is tattered       |       |               |         |                     |                 | VISIBLE    |
      | pmac30       |           |              |           |                          |            |            |                   |                |                       |                   | Book  |               |         |                     |                 | VISIBLE    |
      | pmac31       |           |              |           |                          |            |            |                   |                |                       |                   |       | Carlos        |         |                     |                 | VISIBLE    |
      | pmac32       |           |              |           |                          |            |            |                   |                |                       |                   |       |               | Bryan   |                     |                 | VISIBLE    |
      | pmac33       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     | Ryan            | VISIBLE    |
      | pmac34       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         | Έμπασυ στο Κολωνάκι |                 | VISIBLE    |
      | pmac35       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac36       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac37       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac38       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac39       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac40       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac41       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac42       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | pmac43       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
    And I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"

  Scenario Outline: Searching term by term
    Given I am logged in as "<user>@intersect.org.au"
    When I am on the home page
    And I fill in "Search" with "<search_term>"
    And I press "Search"
    Then I should see search results "<search_results>"
  Examples:
    | user       | search_term | search_results |
    | admin      | Greek       | pmac20         |
    | admin      | window      | pmac21         |
    | admin      | plant pot   | pmac22         |
    | admin      | elephant    | pmac23         |
    | admin      | fron        | pmac24         |
    | admin      | end rear    | pmac24, pmac25 |
    | admin      | Cyprus      | pmac26         |
    | admin      | very        | pmac27         |
    | admin      | brought     | pmac28         |
    | admin      | atter       | pmac29         |
    | admin      | Book        | pmac30         |
    | admin      | Carlos      | pmac31         |
    | admin      | Bryan       | pmac32         |
    | admin      | Ryan        | pmac32, pmac33 |
    | researcher | Greek       | pmac20         |
    | researcher | window      | pmac21         |
    | researcher | plant pot   | pmac22         |
    | researcher | elephant    | pmac23         |
    | researcher | fron        | pmac24         |
    | researcher | end rear    | pmac24, pmac25 |
    | researcher | Cyprus      | pmac26         |
    | researcher | very        | pmac27         |
    | researcher | brought     | pmac28         |
    | researcher | atter       | pmac29         |
    | researcher | Book        | pmac30         |
    | researcher | Carlos      | pmac31         |
    | researcher | Bryan       | pmac32         |
    | researcher | Ryan        | pmac32, pmac33 |

  Scenario: check pagination on search page and doesn't show HIDDEN papyrus records (while not logged in)
    Given I am on the home page
    And I fill in "Search" with "pmac"
    And I press "Search"
    Then I should be on the search results page
    And I should see the pagination controls
    And I should see search results "pmac20, pmac21, pmac22, pmac25, pmac26, pmac27, pmac28, pmac29, pmac30, pmac31, pmac32, pmac33, pmac34, pmac35, pmac36, pmac37, pmac38, pmac39, pmac40, pmac41"

  Scenario: check second page of search results
    Given I am on the home page
    And I fill in "Search" with "pmac"
    And I press "Search"
    Then I should be on the search results page
    When I follow "2"
    Then I should see search results "pmac42, pmac43"

  Scenario Outline: advanced search on text fields
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    And I follow "Advanced"
    Then I should be on the advanced search page
    And I fill in "<field>" with "<term>"
    And I press "Search"
    Then I should be on the advanced search page
    And I should see search results "<result>"
  Examples:
    | field                    | term      | result |
    | general_note             | window    | pmac21 |
    | note                     | plant pot | pmac22 |
    | paleographic_description | elephant  | pmac23 |
    | recto_note               | fron      | pmac24 |
    | verso_note               | end rear  | pmac25 |
    | origin_details           | very      | pmac27 |
    | source_of_acquisition    | brought   | pmac28 |
    | preservation_note        | atter     | pmac29 |
    | language_note            | Carlos    | pmac31 |
    | summary                  | Bryan     | pmac32 |
    | original_text            | Κολωνάκι  | pmac34 |
    | translated_text          | Ryan      | pmac33 |


  Scenario: to check the results table is not present before making a search
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    And I follow "Advanced"
    Then I should not see the search results table

  Scenario: check pagination for advanced search results
    Given I am logged in as "researcher@intersect.org.au"
    And I have papyri
      | inventory_id | general_note |
      | pmac51       | window       |
      | pmac52       | window       |
      | pmac53       | window       |
      | pmac54       | window       |
      | pmac55       | window       |
      | pmac56       | window       |
      | pmac57       | window       |
      | pmac58       | window       |
      | pmac59       | window       |
      | pmac60       | window       |
      | pmac61       | window       |
      | pmac62       | window       |
      | pmac63       | window       |
      | pmac64       | window       |
      | pmac65       | window       |
      | pmac66       | window       |
      | pmac67       | window       |
      | pmac68       | window       |
      | pmac69       | window       |
      | pmac70       | window       |
      | pmac71       | window       |
      | pmac72       | window       |
      | pmac73       | window       |
      | pmac74       | window       |
    And I am on the advanced search page
    And I fill in "general_note" with "window"
    And I press "Search"
    Then I should see the pagination controls

  Scenario: searching for blank should give no results (and not an error)
    Given I am on the home page
    And I press "Search"
    Then I should not see the search results table
    And I should see "Please enter a search query."

  Scenario: searching finds nothing should give "No Results Found" message
    Given I am on the home page
    And I fill in "Search" with "zpmacnothinghere"
    And I press "Search"
    Then I should not see the search results table
    And I should see "No Results Found"

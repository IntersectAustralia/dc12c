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
      | mqt_number | inventory_id | languages | general_note | note      | paleographic_description | recto_note | verso_note | country_of_origin | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary | original_text       | translated_text | visibility |
      | 20         | pmac20       | Greek     |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 21         | pmac21       |           | window wash  |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 22         | pmac22       |           |              | plant pot |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 23         | pmac23       |           |              |           | elephant                 |            |            |                   |                |                       |                   |       |               |         |                     |                 | HIDDEN     |
      | 24         | pmac24       |           |              |           |                          | front end  |            |                   |                |                       |                   |       |               |         |                     |                 | HIDDEN     |
      | 25         | pmac25       |           |              |           |                          |            | rear end   |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 26         | pmac26       |           |              |           |                          |            |            | Cyprus            |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 27         | pmac27       |           |              |           |                          |            |            |                   | very hot place |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 28         | pmac28       |           |              |           |                          |            |            |                   |                | brought from a shop   |                   |       |               |         |                     |                 | VISIBLE    |
      | 29         | pmac29       |           |              |           |                          |            |            |                   |                |                       | is tattered       |       |               |         |                     |                 | VISIBLE    |
      | 30         | pmac30       |           |              |           |                          |            |            |                   |                |                       |                   | Book  |               |         |                     |                 | VISIBLE    |
      | 31         | pmac31       |           |              |           |                          |            |            |                   |                |                       |                   |       | Carlos        |         |                     |                 | VISIBLE    |
      | 32         | pmac32       |           |              |           |                          |            |            |                   |                |                       |                   |       |               | Bryan   |                     |                 | VISIBLE    |
      | 33         | pmac33       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     | Ryan            | VISIBLE    |
      | 34         | pmac34       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         | Έμπασυ στο Κολωνάκι |                 | VISIBLE    |
      | 35         | pmac35       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 36         | pmac36       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 37         | pmac37       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 38         | pmac38       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 39         | pmac39       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 40         | pmac40       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 41         | pmac41       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 42         | pmac42       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 43         | pmac43       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
    And I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"

  Scenario Outline: Searching term by term
    Given I am logged in as "<user>@intersect.org.au"
    When I am on the home page
    And I fill in "Search" with "<search_term>"
    And I press "Search"
    Then I should see search results "MQT <search_results>"
  Examples:
    | user       | search_term | search_results |
    | admin      | Greek       | 20             |
    | admin      | window      | 21             |
    | admin      | plant pot   | 22             |
    | admin      | elephant    | 23             |
    | admin      | fron        | 24             |
    | admin      | end rear    | 24, 25         |
    | admin      | Cyprus      | 26             |
    | admin      | very        | 27             |
    | admin      | brought     | 28             |
    | admin      | atter       | 29             |
    | admin      | Book        | 30             |
    | admin      | Carlos      | 31             |
    | admin      | Bryan       | 32             |
    | admin      | Ryan        | 32, 33         |
    | researcher | Greek       | 20             |
    | researcher | window      | 21             |
    | researcher | plant pot   | 22             |
    | researcher | elephant    | 23             |
    | researcher | fron        | 24             |
    | researcher | end rear    | 24, 25         |
    | researcher | Cyprus      | 26             |
    | researcher | very        | 27             |
    | researcher | brought     | 28             |
    | researcher | atter       | 29             |
    | researcher | Book        | 30             |
    | researcher | Carlos      | 31             |
    | researcher | Bryan       | 32             |
    | researcher | Ryan        | 32, 33         |

  Scenario: check pagination on search page and doesn't show HIDDEN papyrus records (while not logged in)
    Given I am on the home page
    And I fill in "Search" with "pmac"
    And I press "Search"
    Then I should be on the search results page
    And I should see the pagination controls
    And I should see search results "MQT 20, 21, 22, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41"

  Scenario: check second page of search results
    Given I am on the home page
    And I fill in "Search" with "pmac"
    And I press "Search"
    Then I should be on the search results page
    When I follow "2"
    Then I should see search results "MQT 42, 43"

  Scenario Outline: advanced search on text fields
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    And I follow "Advanced"
    Then I should be on the advanced search page
    And I fill in "<field>" with "<term>"
    And I press "Search"
    Then I should be on the advanced search page
    And I should see search results "MQT <result>"
  Examples:
    | field                    | term      | result |
    | general_note             | window    | 21     |
    | note                     | plant pot | 22     |
    | paleographic_description | elephant  | 23     |
    | recto_note               | fron      | 24     |
    | verso_note               | end rear  | 25     |
    | origin_details           | very      | 27     |
    | source_of_acquisition    | brought   | 28     |
    | preservation_note        | atter     | 29     |
    | language_note            | Carlos    | 31     |
    | summary                  | Bryan     | 32     |
    | original_text            | Κολωνάκι  | 34     |
    | translated_text          | Ryan      | 33     |
    | inventory_id             | pmac20    | 20     |


  Scenario: to check the results table is not present before making a search
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    And I follow "Advanced"
    Then I should not see the search results table

  Scenario: check pagination for advanced search results
    Given I am logged in as "researcher@intersect.org.au"
    And I have papyri
      | mqt_number | inventory_id | general_note | visibility |
      | 51         | pmac51       | window       | HIDDEN     |
      | 52         | pmac52       | window       | HIDDEN     |
      | 53         | pmac53       | window       | HIDDEN     |
      | 54         | pmac54       | window       | HIDDEN     |
      | 55         | pmac55       | window       | HIDDEN     |
      | 56         | pmac56       | window       | HIDDEN     |
      | 57         | pmac57       | window       | HIDDEN     |
      | 58         | pmac58       | window       | HIDDEN     |
      | 59         | pmac59       | window       | HIDDEN     |
      | 60         | pmac60       | window       | HIDDEN     |
      | 61         | pmac61       | window       | HIDDEN     |
      | 62         | pmac62       | window       | HIDDEN     |
      | 63         | pmac63       | window       | HIDDEN     |
      | 64         | pmac64       | window       | HIDDEN     |
      | 65         | pmac65       | window       | HIDDEN     |
      | 66         | pmac66       | window       | HIDDEN     |
      | 67         | pmac67       | window       | HIDDEN     |
      | 68         | pmac68       | window       | HIDDEN     |
      | 69         | pmac69       | window       | HIDDEN     |
      | 70         | pmac70       | window       | HIDDEN     |
      | 71         | pmac71       | window       | HIDDEN     |
      | 72         | pmac72       | window       | HIDDEN     |
      | 73         | pmac73       | window       | HIDDEN     |
      | 74         | pmac74       | window       | HIDDEN     |
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

  Scenario: advanced search finds nothing should give "No Results Found" message
    Given I am on the advanced search page
    And I press "Search"
    Then I should not see the search results table
    And I should see "No Results Found"

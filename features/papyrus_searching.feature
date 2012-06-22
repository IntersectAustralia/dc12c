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
    And I have papyri
      | mqt_number | inventory_number | languages | general_note | lines_of_text    | paleographic_description | recto_verso_note | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary | original_text       | translated_text | visibility |
      | 20         | pmac20           | Greek     |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 21         | pmac21           |           | window wash  |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 22         | pmac22           |           |              | plant pot        |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 23         | pmac23           |           |              |                  | elephant                 |                  |                |                       |                   |       |               |         |                     |                 | HIDDEN     |
      | 24         | pmac24           |           |              |                  |                          | front end        |                |                       |                   |       |               |         |                     |                 | HIDDEN     |
      | 27         | pmac27           |           |              |                  |                          |                  | very hot place |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 28         | pmac28           |           |              |                  |                          |                  |                | brought from a shop   |                   |       |               |         |                     |                 | VISIBLE    |
      | 29         | pmac29           |           |              |                  |                          |                  |                |                       | is tattered       |       |               |         |                     |                 | VISIBLE    |
      | 30         | pmac30           |           |              |                  |                          |                  |                |                       |                   | Book  |               |         |                     |                 | VISIBLE    |
      | 31         | pmac31           |           |              |                  |                          |                  |                |                       |                   |       | Carlos        |         |                     |                 | VISIBLE    |
      | 32         | pmac32           |           |              |                  |                          |                  |                |                       |                   |       |               | Bryan   |                     |                 | VISIBLE    |
      | 33         | pmac33           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     | Ryan            | VISIBLE    |
      | 34         | pmac34           |           |              |                  |                          |                  |                |                       |                   |       |               |         | Έμπασυ στο Κολωνάκι |                 | VISIBLE    |
      | 35         | pmac35           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 36         | pmac36           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 37         | pmac37           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 38         | pmac38           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 39         | pmac39           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 40         | pmac40           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 41         | pmac41           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 42         | pmac42           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 43         | pmac43           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
      | 44         | pmac44           |           |              |                  |                          |                  |                |                       |                   |       |               |         |                     |                 | VISIBLE    |
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
    | researcher | fron        |                |
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
    And I should see search results "MQT 20, 21, 22, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43"

  Scenario: check second page of search results
    Given I am on the home page
    And I fill in "Search" with "pmac"
    And I press "Search"
    Then I should be on the search results page
    When I follow "2"
    Then I should see search results "MQT 44"

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
    | lines_of_text            | plant pot | 22     |
    | paleographic_description | elephant  | 23     |
    | recto_verso_note         | fron      | 24     |
    | origin_details           | very      | 27     |
    | source_of_acquisition    | brought   | 28     |
    | preservation_note        | atter     | 29     |
    | language_note            | Carlos    | 31     |
    | summary                  | Bryan     | 32     |
    | original_text            | Κολωνάκι  | 34     |
    | translated_text          | Ryan      | 33     |
    | inventory_number         | pmac20    | 20     |

  Scenario: to check the results table is not present before making a search
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    And I follow "Advanced"
    Then I should not see the search results table

  Scenario: check pagination for advanced search results
    Given I am logged in as "researcher@intersect.org.au"
    And I have papyri
      | mqt_number | inventory_number | general_note | visibility |
      | 51         | pmac51           | window       | HIDDEN     |
      | 52         | pmac52           | window       | HIDDEN     |
      | 53         | pmac53           | window       | HIDDEN     |
      | 54         | pmac54           | window       | HIDDEN     |
      | 55         | pmac55           | window       | HIDDEN     |
      | 56         | pmac56           | window       | HIDDEN     |
      | 57         | pmac57           | window       | HIDDEN     |
      | 58         | pmac58           | window       | HIDDEN     |
      | 59         | pmac59           | window       | HIDDEN     |
      | 60         | pmac60           | window       | HIDDEN     |
      | 61         | pmac61           | window       | HIDDEN     |
      | 62         | pmac62           | window       | HIDDEN     |
      | 63         | pmac63           | window       | HIDDEN     |
      | 64         | pmac64           | window       | HIDDEN     |
      | 65         | pmac65           | window       | HIDDEN     |
      | 66         | pmac66           | window       | HIDDEN     |
      | 67         | pmac67           | window       | HIDDEN     |
      | 68         | pmac68           | window       | HIDDEN     |
      | 69         | pmac69           | window       | HIDDEN     |
      | 70         | pmac70           | window       | HIDDEN     |
      | 71         | pmac71           | window       | HIDDEN     |
      | 72         | pmac72           | window       | HIDDEN     |
      | 73         | pmac73           | window       | HIDDEN     |
      | 74         | pmac74           | window       | HIDDEN     |
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

  @papyrus_per_page_is_infinite
  Scenario: admin should find results in all fields for simple search
    Given I am logged in as "admin@intersect.org.au"
    And I have papyri with visibility "HIDDEN" and a field filled with "abcd" or "123"
      | mqt_number | populated_field               |
      |  52        | mqt_note                      |
      |  53        | inventory_number              |
      |  54        | apis_id                       |
      |  55        | trismegistos_id               |
      |  56        | physical_location             |
      |  57        | languages                     |
      |  58        | dimensions                    |
      |  60        | date_note                     |
      |  61        | general_note                  |
      |  62        | lines_of_text                 |
      |  63        | paleographic_description      |
      |  64        | recto_verso_note              |
      |  65        | origin_details                |
      |  66        | source_of_acquisition         |
      |  67        | preservation_note             |
      |  68        | conservation_note             |
      |  69        | genre                         |
      |  70        | language_note                 |
      |  71        | summary                       |
      |  73        | translated_text               |
      |  74        | other_characteristics         |
      |  75        | material                      |
      |  76        | type_of_text                  |
    And I am on the home page
    Then I fill in "Search" with "abcd 123"
    And I press "Search"
    And I should see search results "MQT 52, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 53, 77, 78, 79"
    
  @papyrus_per_page_is_infinite
  Scenario: researcher should find results in authorized fields for simple search of hidden
    Given I am logged in as "researcher@intersect.org.au"
    And I have papyri with visibility "HIDDEN" and a field filled with "abcd" or "123"
      | mqt_number | populated_field               |
      |  52        | mqt_note                      |
      |  53        | inventory_number              |
      |  54        | apis_id                       |
      |  55        | trismegistos_id               |
      |  56        | physical_location             |
      |  57        | languages                     |
      |  58        | dimensions                    |
      |  60        | date_note                     |
      |  61        | general_note                  |
      |  62        | lines_of_text                 |
      |  63        | paleographic_description      |
      |  64        | recto_verso_note              |
      |  65        | origin_details                |
      |  66        | source_of_acquisition         |
      |  67        | preservation_note             |
      |  68        | conservation_note             |
      |  69        | genre                         |
      |  70        | language_note                 |
      |  71        | summary                       |
      |  73        | translated_text               |
      |  74        | other_characteristics         |
      |  75        | material                      |
      |  76        | type_of_text                  |
    And I am on the home page
    Then I fill in "Search" with "abcd 123"
    And I press "Search"
    And I should see search results "MQT 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 53, 77, 78, 79"

  Scenario: check pagination for advanced search results
    Given I am logged in as "researcher@intersect.org.au"
    And I have papyri
      | mqt_number | inventory_number | general_note | visibility |
      | 1          | inv1             | gen1         | HIDDEN     |
      | 2          | inv2             | gen2         | HIDDEN     |

    When I am on the advanced search page
    And I fill in "inventory_number" with "inv1"
    And I press "Search"
    Then I should see search results "MQT 1"

    When I am on the advanced search page
    And I fill in "general_note" with "gen1"
    And I press "Search"
    Then I should see search results "MQT 1"

    When I am on the advanced search page
    And I fill in "general_note" with "gen1"
    And I fill in "inventory_number" with "inv1"
    And I press "Search"
    Then I should see search results "MQT 1"

    When I am on the advanced search page
    And I fill in "general_note" with "gen1"
    And I fill in "inventory_number" with "inv2"
    And I press "Search"
    Then I should not see the search results table
    And I should see "No Results Found"

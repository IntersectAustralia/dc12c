@wip
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
      | inventory_id | languages | general_note | note      | paleographic_description | recto_note | verso_note | country_of_origin | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary | translated_text |
      | pmac20       | Greek     |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac21       |           | window wash  |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac22       |           |              | plant pot |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac23       |           |              |           | elephant                 |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac24       |           |              |           |                          | front end  |            |                   |                |                       |                   |       |               |         |                 |
      | pmac25       |           |              |           |                          |            | rear end   |                   |                |                       |                   |       |               |         |                 |
      | pmac26       |           |              |           |                          |            |            | Cyprus            |                |                       |                   |       |               |         |                 |
      | pmac27       |           |              |           |                          |            |            |                   | very hot place |                       |                   |       |               |         |                 |
      | pmac28       |           |              |           |                          |            |            |                   |                | brought from a shop   |                   |       |               |         |                 |
      | pmac29       |           |              |           |                          |            |            |                   |                |                       | is tattered       |       |               |         |                 |
      | pmac30       |           |              |           |                          |            |            |                   |                |                       |                   | Book  |               |         |                 |
      | pmac31       |           |              |           |                          |            |            |                   |                |                       |                   |       | Carlos        |         |                 |
      | pmac32       |           |              |           |                          |            |            |                   |                |                       |                   |       |               | Bryan   |                 |
      | pmac33       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         | Ryan            |
      | pmac34       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac35       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac36       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac37       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac38       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac39       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac40       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac41       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac42       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
      | pmac43       |           |              |           |                          |            |            |                   |                |                       |                   |       |               |         |                 |
    And I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"

  Scenario Outline: Searching term by term
    Given I am logged in as "admin@intersect.org.au"
    When I am on the home page
    And I fill in "Search" with "<search_term>"
    And I press "Search"
    Then I should see search results "<search_results>"
  Examples:
    | search_term | search_results |
    | Greek       | pmac20         |
    | window      | pmac21         |
    | plant pot   | pmac22         |
    | elephant    | pmac23         |
    | fron        | pmac24         |
    | end rear    | pmac25         |
    | Cyprus      | pmac26         |
    | very        | pmac27         |
    | brought     | pmac28         |
    | atter       | pmac29         |
    | Book        | pmac30         |
    | Carlos      | pmac31         |
    | Bryan       | pmac32         |
    | Ryan        | pmac32, pmac33 |
Feature: List Papyrus
  As a user
  I want to browse papyrus records

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have papyri
      | inventory_id | visibility |
      | A            | HIDDEN     |
      | B            | VISIBLE    |
      | D            | VISIBLE    |
      | F            | VISIBLE    |
      | C            | HIDDEN     |
      | H            | VISIBLE    |
      | V            | VISIBLE    |
      | E            | HIDDEN     |
      | G            | HIDDEN     |
      | X            | VISIBLE    |
      | I            | VISIBLE    |
      | Z            | VISIBLE    |
      | K            | VISIBLE    |
      | L            | VISIBLE    |
      | M            | HIDDEN     |
      | N            | VISIBLE    |
      | O            | VISIBLE    |
      | P            | VISIBLE    |
      | Q            | VISIBLE    |
      | R            | HIDDEN     |
      | J            | VISIBLE    |
      | S            | VISIBLE    |
      | T            | VISIBLE    |
      | U            | VISIBLE    |
      | W            | VISIBLE    |
      | Y            | VISIBLE    |

  Scenario: View page one
    When I am logged in as "admin@intersect.org.au"
    And I am on the papyri page
    Then I should see the list papyri table
      | Inventory ID | Note | Country of Origin | Translation |
      | A            |      |                   | No          |
      | B            |      |                   | No          |
      | C            |      |                   | No          |
      | D            |      |                   | No          |
      | E            |      |                   | No          |
      | F            |      |                   | No          |
      | G            |      |                   | No          |
      | H            |      |                   | No          |
      | I            |      |                   | No          |
      | J            |      |                   | No          |
      | K            |      |                   | No          |
      | L            |      |                   | No          |
      | M            |      |                   | No          |
      | N            |      |                   | No          |
      | O            |      |                   | No          |
      | P            |      |                   | No          |
      | Q            |      |                   | No          |
      | R            |      |                   | No          |
      | S            |      |                   | No          |
      | T            |      |                   | No          |
   And I should see the pagination controls

  Scenario: View page two
    When I am logged in as "admin@intersect.org.au"
    And I am on page 2 of the papyri index
    Then I should see the list papyri table
      | Inventory ID | Note | Country of Origin | Translation |
      | U            |      |                   | No          |
      | V            |      |                   | No          |
      | W            |      |                   | No          |
      | X            |      |                   | No          |
      | Y            |      |                   | No          |
      | Z            |      |                   | No          |
    And I should see the pagination controls

  Scenario: Public users should not see hidden records
    Given I am on the papyri page
    Then I should see the list papyri table
      | Inventory ID | Note | Country of Origin | Translation |
      | B            |      |                   | No          |
      | D            |      |                   | No          |
      | F            |      |                   | No          |
      | H            |      |                   | No          |
      | I            |      |                   | No          |
      | J            |      |                   | No          |
      | K            |      |                   | No          |
      | L            |      |                   | No          |
      | N            |      |                   | No          |
      | O            |      |                   | No          |
      | P            |      |                   | No          |
      | Q            |      |                   | No          |
      | S            |      |                   | No          |
      | T            |      |                   | No          |
      | U            |      |                   | No          |
      | V            |      |                   | No          |
      | W            |      |                   | No          |
      | X            |      |                   | No          |
      | Y            |      |                   | No          |
      | Z            |      |                   | No          |
    And I should not see the pagination controls


  Scenario Outline: ensure invalid page numbers default to show page 1
    When I am logged in as "admin@intersect.org.au"
    And I am on page <page> of the papyri index
    Then I should see the list papyri table
      | Inventory ID | Note | Country of Origin | Translation |
      | A            |      |                   | No          |
      | B            |      |                   | No          |
      | C            |      |                   | No          |
      | D            |      |                   | No          |
      | E            |      |                   | No          |
      | F            |      |                   | No          |
      | G            |      |                   | No          |
      | H            |      |                   | No          |
      | I            |      |                   | No          |
      | J            |      |                   | No          |
      | K            |      |                   | No          |
      | L            |      |                   | No          |
      | M            |      |                   | No          |
      | N            |      |                   | No          |
      | O            |      |                   | No          |
      | P            |      |                   | No          |
      | Q            |      |                   | No          |
      | R            |      |                   | No          |
      | S            |      |                   | No          |
      | T            |      |                   | No          |
    And I should see the pagination controls
  Examples:
    | page |
    | 0    |
    | -1   |
    | ert  |

  Scenario: Entering a page number greater than max doesn't throw an error
    Given I am on page 1000000000 of the papyri index
    Then I should see the list papyri table
      | Inventory ID | Note | Country of Origin | Translation |
    And I should not see the pagination controls




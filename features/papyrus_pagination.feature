@wip
Feature: List Papyrus
  As a user
  I want to browse papyrus records

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have papyri
      | inventory_id |
      | A            |
      | B            |
      | D            |
      | F            |
      | C            |
      | H            |
      | V            |
      | E            |
      | G            |
      | X            |
      | I            |
      | Z            |
      | K            |
      | L            |
      | M            |
      | N            |
      | O            |
      | P            |
      | Q            |
      | R            |
      | J            |
      | S            |
      | T            |
      | U            |
      | W            |
      | Y            |

  Scenario: View page one
    When I am logged in as "admin@intersect.org.au"
    And I am on the papyri page
    Then I should see the list papyri table
      | Inventory ID | Note           | Country of Origin | Translation |
      | A            |                |                   | No          |
      | B            |                |                   | No          |
      | C            |                |                   | No          |
      | D            |                |                   | No          |
      | E            |                |                   | No          |
      | F            |                |                   | No          |
      | G            |                |                   | No          |
      | H            |                |                   | No          |
      | I            |                |                   | No          |
      | J            |                |                   | No          |
      | K            |                |                   | No          |
      | L            |                |                   | No          |
      | M            |                |                   | No          |
      | N            |                |                   | No          |
      | O            |                |                   | No          |
      | P            |                |                   | No          |
      | Q            |                |                   | No          |
      | R            |                |                   | No          |
      | S            |                |                   | No          |
      | T            |                |                   | No          |

  Scenario: View page two
    When I am logged in as "admin@intersect.org.au"
    And I am on page 2 of the papyri index
    Then I should see the list papyri table
      | Inventory ID | Note           | Country of Origin | Translation |
      | U            |                |                   | No          |
      | V            |                |                   | No          |
      | W            |                |                   | No          |
      | X            |                |                   | No          |
      | Y            |                |                   | No          |
      | Z            |                |                   | No          |

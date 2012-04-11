Feature: List Papyrus
  As a user
  I want to browse papyrus records

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have papyri
      | mqt_number | inventory_id | visibility |
      | 1          | A            | HIDDEN     |
      | 2          | B            | VISIBLE    |
      | 3          | D            | VISIBLE    |
      | 4          | F            | VISIBLE    |
      | 5          | C            | HIDDEN     |
      | 6          | H            | VISIBLE    |
      | 7          | V            | VISIBLE    |
      | 8          | E            | HIDDEN     |
      | 9          | G            | HIDDEN     |
      | 10         | X            | VISIBLE    |
      | 11         | I            | VISIBLE    |
      | 12         | Z            | VISIBLE    |
      | 13         | K            | VISIBLE    |
      | 14         | L            | VISIBLE    |
      | 15         | M            | HIDDEN     |
      | 16         | N            | VISIBLE    |
      | 17         | O            | VISIBLE    |
      | 18         | P            | VISIBLE    |
      | 19         | Q            | VISIBLE    |
      | 20         | R            | HIDDEN     |
      | 21         | J            | VISIBLE    |
      | 22         | S            | VISIBLE    |
      | 23         | T            | VISIBLE    |
      | 24         | U            | VISIBLE    |
      | 25         | W            | VISIBLE    |
      | 26         | Y            | VISIBLE    |

  Scenario: View page one
    When I am logged in as "admin@intersect.org.au"
    And I am on the papyri page
    Then I should see the list papyri table
      | MQT Number | Inventory ID | Note | Country of Origin | Translation |
      | MQT 1      | A            |      |                   | No          |
      | MQT 2      | B            |      |                   | No          |
      | MQT 5      | C            |      |                   | No          |
      | MQT 3      | D            |      |                   | No          |
      | MQT 8      | E            |      |                   | No          |
      | MQT 4      | F            |      |                   | No          |
      | MQT 9      | G            |      |                   | No          |
      | MQT 6      | H            |      |                   | No          |
      | MQT 11     | I            |      |                   | No          |
      | MQT 21     | J            |      |                   | No          |
      | MQT 13     | K            |      |                   | No          |
      | MQT 14     | L            |      |                   | No          |
      | MQT 15     | M            |      |                   | No          |
      | MQT 16     | N            |      |                   | No          |
      | MQT 17     | O            |      |                   | No          |
      | MQT 18     | P            |      |                   | No          |
      | MQT 19     | Q            |      |                   | No          |
      | MQT 20     | R            |      |                   | No          |
      | MQT 22     | S            |      |                   | No          |
      | MQT 23     | T            |      |                   | No          |
   And I should see the pagination controls

  Scenario: View page two
    When I am logged in as "admin@intersect.org.au"
    And I am on page 2 of the papyri index
    Then I should see the list papyri table
      | MQT Number | Inventory ID | Note | Country of Origin | Translation |
      | MQT 24     | U            |      |                   | No          |
      | MQT 7      | V            |      |                   | No          |
      | MQT 25     | W            |      |                   | No          |
      | MQT 10     | X            |      |                   | No          |
      | MQT 26     | Y            |      |                   | No          |
      | MQT 12     | Z            |      |                   | No          |
    And I should see the pagination controls

  Scenario: Public users should not see hidden records
    Given I am on the papyri page
    Then I should see the list papyri table
      | MQT Number | Inventory ID | Note | Country of Origin | Translation |
      | MQT 2      | B            |      |                   | No          |
      | MQT 3      | D            |      |                   | No          |
      | MQT 4      | F            |      |                   | No          |
      | MQT 6      | H            |      |                   | No          |
      | MQT 11     | I            |      |                   | No          |
      | MQT 21     | J            |      |                   | No          |
      | MQT 13     | K            |      |                   | No          |
      | MQT 14     | L            |      |                   | No          |
      | MQT 16     | N            |      |                   | No          |
      | MQT 17     | O            |      |                   | No          |
      | MQT 18     | P            |      |                   | No          |
      | MQT 19     | Q            |      |                   | No          |
      | MQT 22     | S            |      |                   | No          |
      | MQT 23     | T            |      |                   | No          |
      | MQT 24     | U            |      |                   | No          |
      | MQT 7      | V            |      |                   | No          |
      | MQT 25     | W            |      |                   | No          |
      | MQT 10     | X            |      |                   | No          |
      | MQT 26     | Y            |      |                   | No          |
      | MQT 12     | Z            |      |                   | No          |
    And I should not see the pagination controls


  Scenario Outline: ensure invalid page numbers default to show page 1
    When I am logged in as "admin@intersect.org.au"
    And I am on page <page> of the papyri index
    Then I should see the list papyri table
      | MQT Number | Inventory ID | Note | Country of Origin | Translation |
      | MQT 1      | A            |      |                   | No          |
      | MQT 2      | B            |      |                   | No          |
      | MQT 5      | C            |      |                   | No          |
      | MQT 3      | D            |      |                   | No          |
      | MQT 8      | E            |      |                   | No          |
      | MQT 4      | F            |      |                   | No          |
      | MQT 9      | G            |      |                   | No          |
      | MQT 6      | H            |      |                   | No          |
      | MQT 11     | I            |      |                   | No          |
      | MQT 21     | J            |      |                   | No          |
      | MQT 13     | K            |      |                   | No          |
      | MQT 14     | L            |      |                   | No          |
      | MQT 15     | M            |      |                   | No          |
      | MQT 16     | N            |      |                   | No          |
      | MQT 17     | O            |      |                   | No          |
      | MQT 18     | P            |      |                   | No          |
      | MQT 19     | Q            |      |                   | No          |
      | MQT 20     | R            |      |                   | No          |
      | MQT 22     | S            |      |                   | No          |
      | MQT 23     | T            |      |                   | No          |
    And I should see the pagination controls
  Examples:
    | page |
    | 0    |
    | -1   |
    | ert  |

  Scenario: Entering a page number greater than max doesn't throw an error
    Given I am on page 1000000000 of the papyri index
    Then I should see the list papyri table
      | MQT Number | Inventory ID | Note | Country of Origin | Translation |
    And I should not see the pagination controls




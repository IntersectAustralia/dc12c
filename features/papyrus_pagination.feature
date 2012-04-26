Feature: List Papyrus
  As a user
  I want to browse papyrus records

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"
    And I have papyri
      | mqt_number | visibility |
      | 1          | HIDDEN     |
      | 2          | VISIBLE    |
      | 4          | VISIBLE    |
      | 6          | VISIBLE    |
      | 3          | HIDDEN     |
      | 8          | VISIBLE    |
      | 22         | VISIBLE    |
      | 5          | HIDDEN     |
      | 7          | HIDDEN     |
      | 24         | VISIBLE    |
      | 9          | VISIBLE    |
      | 26         | VISIBLE    |
      | 11         | VISIBLE    |
      | 12         | VISIBLE    |
      | 13         | HIDDEN     |
      | 14         | VISIBLE    |
      | 15         | VISIBLE    |
      | 16         | VISIBLE    |
      | 17         | VISIBLE    |
      | 18         | HIDDEN     |
      | 10         | VISIBLE    |
      | 19         | VISIBLE    |
      | 20         | VISIBLE    |
      | 21         | VISIBLE    |
      | 23         | VISIBLE    |
      | 25         | VISIBLE    |

  Scenario: View page one
    When I am logged in as "admin@intersect.org.au"
    And I am on the papyri page
    Then I should see the list papyri table
      | MQT Number | Lines of Text | Translation |
      | MQT 1      |               | No          |
      | MQT 2      |               | No          |
      | MQT 3      |               | No          |
      | MQT 4      |               | No          |
      | MQT 5      |               | No          |
      | MQT 6      |               | No          |
      | MQT 7      |               | No          |
      | MQT 8      |               | No          |
      | MQT 9      |               | No          |
      | MQT 10     |               | No          |
      | MQT 11     |               | No          |
      | MQT 12     |               | No          |
      | MQT 13     |               | No          |
      | MQT 14     |               | No          |
      | MQT 15     |               | No          |
      | MQT 16     |               | No          |
      | MQT 17     |               | No          |
      | MQT 18     |               | No          |
      | MQT 19     |               | No          |
      | MQT 20     |               | No          |
   And I should see the pagination controls

  Scenario: View page two
    When I am logged in as "admin@intersect.org.au"
    And I am on page 2 of the papyri index
    Then I should see the list papyri table
      | MQT Number | Lines of Text | Translation |
      | MQT 21     |               | No          |
      | MQT 22     |               | No          |
      | MQT 23     |               | No          |
      | MQT 24     |               | No          |
      | MQT 25     |               | No          |
      | MQT 26     |               | No          |
    And I should see the pagination controls

  Scenario: Public users should not see hidden records
    Given I am on the papyri page
    Then I should see the list papyri table
      | MQT Number | Lines of Text | Translation |
      | MQT 2      |               | No          |
      | MQT 4      |               | No          |
      | MQT 6      |               | No          |
      | MQT 8      |               | No          |
      | MQT 9      |               | No          |
      | MQT 10     |               | No          |
      | MQT 11     |               | No          |
      | MQT 12     |               | No          |
      | MQT 14     |               | No          |
      | MQT 15     |               | No          |
      | MQT 16     |               | No          |
      | MQT 17     |               | No          |
      | MQT 19     |               | No          |
      | MQT 20     |               | No          |
      | MQT 21     |               | No          |
      | MQT 22     |               | No          |
      | MQT 23     |               | No          |
      | MQT 24     |               | No          |
      | MQT 25     |               | No          |
      | MQT 26     |               | No          |
    And I should not see the pagination controls

  Scenario Outline: ensure invalid page numbers default to show page 1
    When I am logged in as "admin@intersect.org.au"
    And I am on page <page> of the papyri index
    Then I should see the list papyri table
      | MQT Number | Lines of Text | Translation |
      | MQT 1      |               | No          |
      | MQT 2      |               | No          |
      | MQT 3      |               | No          |
      | MQT 4      |               | No          |
      | MQT 5      |               | No          |
      | MQT 6      |               | No          |
      | MQT 7      |               | No          |
      | MQT 8      |               | No          |
      | MQT 9      |               | No          |
      | MQT 10     |               | No          |
      | MQT 11     |               | No          |
      | MQT 12     |               | No          |
      | MQT 13     |               | No          |
      | MQT 14     |               | No          |
      | MQT 15     |               | No          |
      | MQT 16     |               | No          |
      | MQT 17     |               | No          |
      | MQT 18     |               | No          |
      | MQT 19     |               | No          |
      | MQT 20     |               | No          |
    And I should see the pagination controls
  Examples:
    | page |
    | 0    |
    | -1   |
    | ert  |

  Scenario: Entering a page number greater than max doesn't throw an error
    Given I am on page 1000000000 of the papyri index
    Then I should see the list papyri table
      | MQT Number | Lines of Text | Translation |
    And I should not see the pagination controls

  Scenario: new papyrus link is not displayed on list page for researcher
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the papyri page
    Then I should not see link "New Papyrus"

  Scenario: new papyrus link is not displayed on list page for anonymous
    Given I am on the papyri page
    Then I should not see link "New Papyrus"

  Scenario: list page does not say "Search Results"
    Given I am on the papyri page
    Then I should not see "Search results"

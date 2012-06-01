Feature: In order to integrate with papyri.info
  As an anonymous user
  I want to download a zip file containing XMLs of papyri

  Background:
    Given I have languages
      | name     |
      | Greek    |
      | Coptic   |
    And I have genres
      | name   |
      | Letter |
      | Book   |

  Scenario: link exists
    When I am on the admin page
    And I follow "Download papyri.info zip"
    Then I should receive a zip file matching "features/samples/empty"

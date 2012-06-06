Feature: In order to integrate with papyri.info
  As an anonymous user
  I want to download a zip file containing XMLs of papyri

  @urlhack
  Scenario: link exists
    When I am on the admin page
    And I follow "Download papyri.info zip"
    Then I should receive a zip file "macquarie_papyri.zip" containing XMLs like in directory "features/samples/empty"

  @urlhack
  Scenario: basic XML
    Given I have the test papyri for papyri.info
    And I have a papyrus
      | mqt_number | visibility |
      | 99         | HIDDEN     |
    When I am on the admin page
    And I follow "Download papyri.info zip"
    Then I should receive a zip file "macquarie_papyri.zip" containing XMLs like in directory "features/samples/expected_zip"

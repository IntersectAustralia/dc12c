Feature: In order to control access
  As an administrator
  I want to change the visibility of a papyrus

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"
    And I have papyri
      | mqt_number | visibility |
      | 1          | HIDDEN     |
      | 2          | VISIBLE    |
      | 3          | PUBLIC     |

  Scenario Outline: Changing visibilities
    Given I am logged in as "admin@intersect.org.au"
    Given I am on the "MQT <mqt>" papyrus page
    Then I should see buttons "<pre_see>" and not "<pre_not_see>"

    When I press "<button_to_press>"

    Then I should be on the "MQT <mqt>" papyrus page
    Then I should see buttons "<post_see>" and not "<button_to_press>"
    And I should see "<message>"

    Examples:
      | mqt | pre_see                   | pre_not_see  | button_to_press | post_see                  | message                    |
      | 1   | Make Visible, Make Public | Make Hidden  | Make Visible    | Make Hidden, Make Public  | The papyrus is now visible |
      | 1   | Make Visible, Make Public | Make Hidden  | Make Public     | Make Hidden, Make Visible | The papyrus is now public  |
      | 2   | Make Hidden, Make Public  | Make Visible | Make Hidden     | Make Visible, Make Public | The papyrus is now hidden  |
      | 2   | Make Hidden, Make Public  | Make Visible | Make Public     | Make Hidden, Make Visible | The papyrus is now public  |
      | 3   | Make Hidden, Make Visible | Make Public  | Make Hidden     | Make Visible, Make Public | The papyrus is now hidden  |
      | 3   | Make Hidden, Make Visible | Make Public  | Make Visible    | Make Hidden, Make Public  | The papyrus is now visible |

  Scenario: Anonymous sees no buttons
    When I am on the "MQT 2" papyrus page
    Then I should see buttons "" and not "Make Hidden, Make Visible, Make Public"

    When I am on the "MQT 3" papyrus page
    Then I should see buttons "" and not "Make Hidden, Make Visible, Make Public"

  Scenario: Researcher sees no buttons
    Given I am logged in as "researcher@intersect.org.au"

    When I am on the "MQT 1" papyrus page
    Then I should see buttons "" and not "Make Hidden, Make Visible, Make Public"

    When I am on the "MQT 2" papyrus page
    Then I should see buttons "" and not "Make Hidden, Make Visible, Make Public"

    When I am on the "MQT 3" papyrus page
    Then I should see buttons "" and not "Make Hidden, Make Visible, Make Public"

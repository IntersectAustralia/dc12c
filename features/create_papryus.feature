Feature: Create Papyrus
  As an admin
  I want to create a new papyrus record

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I have a user "researcher@intersect.org.au" with role "Researcher"
    And I have languages
      | name     |
      | Greek    |
      | Coptic   |
      | Egyptian |
      | Demotic  |
      | Latin    |
    And I have genres
      | name          |
      | Letter        |
      | book          |
      | book fragment |
    And I have countries
      | name   |
      | Greece |
      | Egypt  |
      | Cyprus |
      | Turkey |

  Scenario: Creating Papyrus
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    When I follow "Create Papyrus"
    Then I should see fields displayed
      | field                    | value |
      | Inventory ID             |       |
      | Languages                |       |
      | Width                    |       |
      | Height                   |       |
      | Date                     |       |
      | General Note             |       |
      | Note                     |       |
      | Paleographic Description |       |
      | Recto Note               |       |
      | Verso Note               |       |
      | Country of Origin        |       |
      | Origin Details           |       |
      | Source of Acquisition    |       |
      | Preservation Note        |       |
      | Genre                    |       |
      | Language Note            |       |
      | Summary                  |       |
      | Original Text            |       |
      | Translated Text          |       |

    When I enter the following papyrus details
      | field                    | value                     |
      | Inventory ID             | 24gac                     |
      | Languages                | Greek, Coptic             |
      | Width                    | 50                        |
      | Height                   | 40                        |
      | Date                     | 234 CE                    |
      | General Note             | this is a papyrus         |
      | Note                     | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Note               | it's shiny                |
      | Verso Note               | not so shiny              |
      | Country of Origin        | Greece                    |
      | Origin Details           | greece                    |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Genre                    | Letter                    |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |




    Then show me the page
    And I press "Save"
    Then I should see "Your Papyrus record has been created."
    And I should be on the "24gac" papyrus page
    And I should see the following papyrus details
      | field                    | value                     |
      | Inventory ID             | 24gac                     |
      | Languages                | Coptic, Greek             |
      | Width                    | 50                        |
      | Height                   | 40                        |
      | Date                     | 234 CE                    |
      | General Note             | this is a papyrus         |
      | Note                     | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Note               | it's shiny                |
      | Verso Note               | not so shiny              |
      | Country of Origin        | Greece                    |
      | Origin Details           | greece                    |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Genre                    | Letter                    |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |

  Scenario: Researcher cannot create a papyrus record
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the homepage
    Then I should not see "Create Papyrus"
    When I am on the new papyrus page
    Then I should be on the home page
    And I should see "You are not authorized to access this page"

  Scenario: If not logged in I cannot create a papyrus record
    When I am on the homepage
    Then I should not see "Create Papyrus"
    When I am on the new papyrus page
    Then I should be on the home page
    And I should see "You are not authorized to access this page"

  Scenario: Creating Papyrus with only mandatory fields
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    When I follow "Create Papyrus"
    When I enter the following papyrus details
      | field        | value |
      | Inventory ID | 24gac |
    And I press "Save"
    Then I should see "Your Papyrus record has been created."
    And I should be on the "24gac" papyrus page
    And I should see the following papyrus details
      | field                    | value |
      | Inventory ID             | 24gac |
      | Languages                |       |
      | Width                    |       |
      | Height                   |       |
      | Date                     |       |
      | General Note             |       |
      | Note                     |       |
      | Paleographic Description |       |
      | Recto Note               |       |
      | Verso Note               |       |
      | Country of Origin        |       |
      | Origin Details           |       |
      | Source of Acquisition    |       |
      | Preservation Note        |       |
      | Genre                    |       |
      | Language Note            |       |
      | Summary                  |       |
      | Original Text            |       |
      | Translated Text          |       |

  Scenario: Creating Papyrus with wrong fields
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    When I follow "Create Papyrus"
    When I enter the following papyrus details
      | field        | value |
      | Inventory ID |       |
      | Width        | -1    |
      | Height       | 0     |
      | Date         | -2 CE |
    And I press "Save"
    Then I should not see "Your Papyrus record has been created."
    And I should see "Date year must be greater than 0"
    And I should see "Inventory ID can't be blank"
    And I should see "Width must be greater than 0"
    And I should see "Height must be greater than 0"
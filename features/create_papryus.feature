Feature: Create Papyrus
  As an admin
  I want to create a new papyrus record

  Background:
    Given I have a user "admin@intersect.org.au" with role "Administrator"
    And I am logged in as "admin@intersect.org.au"

  Scenario: Creating Papyrus
    Given I am on the home page
    When I follow "Create Papyrus"
    Then I should see fields displayed
      | field                    | value |
      | Inventory ID             |       |
      | Width                    |       |
      | Height                   |       |
      | General Note             |       |
      | Note                     |       |
      | Paleographic Description |       |
      | Recto Note               |       |
      | Verso Note               |       |
      | Origin Details           |       |
      | Source of Acquisition    |       |
      | Preservation Note        |       |
      | Language Note            |       |
      | Summary                  |       |
      | Original Text            |       |
      | Translated Text          |       |
    When I enter the following papyrus details
      | field                    | value                     |
      | Inventory ID             | 24gac                     |
      | Width                    | 50                        |
      | Height                   | 40                        |
      | General Note             | this is a papyrus         |
      | Note                     | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Note               | it's shiny                |
      | Verso Note               | not so shiny              |
      | Origin Details           | greece                    |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |
    And I press "Save"
    Then I should see "Your Papyrus record has been created."
    And I should be on the "24gac" papyrus page
    Then show me the page
    Then I should see the following papyrus details
      | field                    | value                     |
      | Inventory ID             | 24gac                     |
      | Width                    | 50                        |
      | Height                   | 40                        |
      | General Note             | this is a papyrus         |
      | Note                     | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Note               | it's shiny                |
      | Verso Note               | not so shiny              |
      | Origin Details           | greece                    |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |



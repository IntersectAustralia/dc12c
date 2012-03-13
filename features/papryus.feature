Feature: Manage Papyrus
  As an admin
  I want to create and edit papyrus records

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
      | Book          |
      | Book Fragment |
    And I have countries
      | name   |
      | Greece |
      | Egypt  |
      | Cyprus |
      | Turkey |
    And I have a papyrus
      | inventory_id | languages     | width | height | date  | general_note | note          | paleographic_description | recto_note | verso_note | country_of_origin | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary             | original_text | translated_text | visibility |
      | p.macq2      | Coptic, Greek | 30    | 77     | 88 CE | General Blah | Specific blah | Paleo Diet               | Rectangle  | Verses     | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | PUBLIC     |
    And I have a papyrus
      | inventory_id | languages       | width | height | date   | general_note  | note           | visibility |
      | hidden.macq  | Coptic, Demotic | 60    | 177    | 488 CE | General stuff | Specific stuff | HIDDEN     |
    And I have a papyrus
      | inventory_id | languages       | width | height | date   | general_note  | note           | visibility |
      | visible.macq  | Coptic, Demotic | 60    | 177    | 488 CE | General stuff | Specific stuff | VISIBLE     |

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
    And "24gac" should have a visibility of "HIDDEN"

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

  Scenario: Editing a Papyrus record (logged in as researcher)
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "p.macq2" papyrus page
    Then I should not see link "Edit this record"
    When I am on the "p.macq2" edit papyrus page
    Then I should be on the home page
    And I should see "You are not authorized to access this page"


  Scenario: Editing a Papyrus record (not logged in)
    Given I am on the "p.macq2" papyrus page
    Then I should not see link "Edit this record"
    When I am on the "p.macq2" edit papyrus page
    Then I should be on the home page
    And I should see "You are not authorized to access this page"


  Scenario: Editing a Papyrus record (logged in as administrator)
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "p.macq2" papyrus page
    When I follow "Edit this record"
    Then I should be on the "p.macq2" edit papyrus page
    Then I should see papyrus fields displayed
      | field                    | value               |
      | Inventory ID             | p.macq2             |
      | Languages                | Coptic, Greek       |
      | Width                    | 30                  |
      | Height                   | 77                  |
      | Date                     | 88 CE               |
      | General Note             | General Blah        |
      | Note                     | Specific blah       |
      | Paleographic Description | Paleo Diet          |
      | Recto Note               | Rectangle           |
      | Verso Note               | Verses              |
      | Country of Origin        | Greece              |
      | Origin Details           | It's Greek.         |
      | Source of Acquisition    | Got it from Greece  |
      | Preservation Note        | poorly preserved    |
      | Genre                    | Book                |
      | Language Note            | Fancy Greek         |
      | Summary                  | don't understand it |
      | Original Text            | περιοχής            |
      | Translated Text          | area                |
    When I enter the following papyrus details
      | field                    | value                     |
      | Inventory ID             | 24gac                     |
      | Width                    | 50                        |
      | Height                   | 40                        |
      | Date                     | 234 CE                    |
      | General Note             | this is a papyrus         |
      | Note                     | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Note               | it's shiny                |
      | Verso Note               | not so shiny              |
      | Country of Origin        | Turkey                    |
      | Origin Details           | Turkish                   |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Genre                    | Letter                    |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |
    And I uncheck "Coptic"
    And I uncheck "Greek"
    And I check "Egyptian"
    And I check "Latin"
    And I press "Save"
    Then I should see "Papyrus was successfully updated."
    And I should see the following papyrus details
      | field                    | value                     |
      | Inventory ID             | 24gac                     |
      | Languages                | Egyptian, Latin           |
      | Width                    | 50                        |
      | Height                   | 40                        |
      | Date                     | 234 CE                    |
      | General Note             | this is a papyrus         |
      | Note                     | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Note               | it's shiny                |
      | Verso Note               | not so shiny              |
      | Country of Origin        | Turkey                    |
      | Origin Details           | Turkish                   |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Genre                    | Letter                    |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |
    And I should be on the "24gac" papyrus page


  Scenario: Editing a Papyrus record and unchecking all languages (logged in as administrator)
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "p.macq2" papyrus page
    When I follow "Edit this record"
    Then I should be on the "p.macq2" edit papyrus page
    Then I should see papyrus fields displayed
      | field                    | value               |
      | Inventory ID             | p.macq2             |
      | Languages                | Coptic, Greek       |
      | Width                    | 30                  |
      | Height                   | 77                  |
      | Date                     | 88 CE               |
      | General Note             | General Blah        |
      | Note                     | Specific blah       |
      | Paleographic Description | Paleo Diet          |
      | Recto Note               | Rectangle           |
      | Verso Note               | Verses              |
      | Country of Origin        | Greece              |
      | Origin Details           | It's Greek.         |
      | Source of Acquisition    | Got it from Greece  |
      | Preservation Note        | poorly preserved    |
      | Genre                    | Book                |
      | Language Note            | Fancy Greek         |
      | Summary                  | don't understand it |
      | Original Text            | περιοχής            |
      | Translated Text          | area                |
    And I uncheck "Coptic"
    And I uncheck "Greek"
    And I press "Save"
    Then I should see "Papyrus was successfully updated."
    And I should be on the "p.macq2" papyrus page
    And I should see the following papyrus details
      | field     | value |
      | Languages |       |

  Scenario: Failing edit of papyrus record
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "p.macq2" papyrus page
    When I follow "Edit this record"
    Then I should be on the "p.macq2" edit papyrus page
    When I enter the following papyrus details
      | field | value |
      | Date  | 0 CE  |
    And I press "Save"
    Then I should not see "Papyrus was successfully updated."
    And I should see "Date year must be greater than 0"

  Scenario: Viewing a Papyrus record (logged in as administrator)
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "hidden.macq" papyrus page
    Then I should see "Record is hidden"
    And I am on the "p.macq2" papyrus page
    Then I should see "Record is public"
    And I am on the "visible.macq" papyrus page
    Then I should see "Record is visible"

  Scenario: Viewing a Papyrus record (logged in as Researcher)
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "hidden.macq" papyrus page
    Then I should not see "Record is hidden"
    And I am on the "p.macq2" papyrus page
    Then I should not see "Record is public"
    And I am on the "visible.macq" papyrus page
    Then I should not see "Record is visible"

  Scenario: Anonymous user should only see public papyri records
    When I am on the "hidden.macq" papyrus page
    Then I should be on the home page
    And I should see "You are not authorized to access this page"

    When I am on the "p.macq2" papyrus page
    Then I should be on the "p.macq2" papyrus page
    And I should not see "You are not authorized to access this page"

    When I am on the "visible.macq" papyrus page
    Then I should be on the "visible.macq" papyrus page
    And I should not see "You are not authorized to access this page"
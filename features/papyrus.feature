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
      | mqt_number | mqt_note | inventory_id | languages     | dimensions     | date_from  | general_note | note          | paleographic_description | recto_note | verso_note | country_of_origin | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary             | original_text | translated_text | visibility |
      | 2          | note too | p.macq2      | Coptic, Greek | 5 x 6 cm       | 88 CE | General Blah | Specific blah | Paleo Diet               | Rectangle  | Verses     | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | PUBLIC     |
    And I have papyri
      | mqt_number | inventory_id | languages       | dimensions     | date_from   | general_note  | note           | visibility | country_of_origin |
      | 3          | hidden.macq  | Coptic, Demotic | 5 x 7 cm       | 488 CE      | General stuff | Specific stuff | HIDDEN     | Turkey            |
      | 4          | visible.macq | Coptic, Demotic | 5 x 8 cm       | 488 CE      | General stuff | Specific stuff | VISIBLE    | Turkey            |

  Scenario: half-clearing date
    Given I am logged in as "admin@intersect.org.au"
    And I have a papyrus
      | mqt_number | inventory_id | date_from | date_to | visibility |
      | 6          | dateful      | 488 CE    | 1234 CE | HIDDEN     |
    And I am on the "MQT 6" edit papyrus page
    When I enter the following papyrus details
      | field     | value |
      | Date From | 123   |
      | Date To   | 234   |
    And I press "Save"
    Then I should see "Papyrus was successfully updated."
    Then I should see fields displayed
      | field        | value   |
      | Inventory ID | dateful |
    And Date should be empty

  Scenario: Deleting date
    Given I am logged in as "admin@intersect.org.au"
    And I have a papyrus
      | mqt_number | inventory_id | date_from | date_to | visibility |
      | 6          | dateful      | 488 CE    | 1234 CE | HIDDEN     |
    And I am on the "MQT 6" edit papyrus page
    When I enter the following papyrus details
      | field     | value |
      | Date From |       |
      | Date To   |       |
    And I press "Save"
    Then I should see "Papyrus was successfully updated."
    Then I should see fields displayed
      | field        | value   |
      | Inventory ID | dateful |
    And Date should be empty

  Scenario: Creating Papyrus
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    When I follow "Create Papyrus"
    Then I should see fields displayed
      | field                    | value |
      | MQT Number               |       |
      | MQT Note                 |       |
      | Inventory ID             |       |
      | APIS ID                  |       |
      | Trismegistos ID          |       |
      | Languages                |       |
      | Dimensions               |       |
      | Date From                |       |
      | Date To                  |       |
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
      | MQT Number               | 5                         |
      | MQT Note                 | from #2                   |
      | Inventory ID             | 24gac                     |
      | APIS ID                  | P1234                     |
      | Trismegistos ID          | 12345                     |
      | Languages                | Greek, Coptic             |
      | Dimensions               | (a) 2 x 3cm, (b) same     |
      | Date From                | 234 BCE                   |
      | Date To                  | 233 CE                    |
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
    And I should be on the "MQT 5" papyrus page
    And I should see the following papyrus details
      | field                    | value                     |
      | MQT Number               | MQT 5                     |
      | MQT Note                 | from #2                   |
      | Inventory ID             | 24gac                     |
      | APIS ID                  | P1234                     |
      | Trismegistos ID          | 12345                     |
      | Languages                | Coptic, Greek             |
      | Dimensions               | (a) 2 x 3cm, (b) same     |
      | Date                     | 234 BCE - 233 CE          |
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
    And "MQT 5" should have a visibility of "HIDDEN"

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
      | MQT Number   | 6     |
    And I press "Save"
    Then I should see "Your Papyrus record has been created."
    And I should be on the "MQT 6" papyrus page
    And I should see the following papyrus details
      | field                    | value |
      | MQT Number               | MQT 6 |
      | MQT Note                 |       |
      | Inventory ID             |       |
      | APIS ID                  |       |
      | Trismegistos ID          |       |
      | Languages                |       |
      | Dimensions               |       |
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
      | field            | value |
      | MQT Number       | 3     |
      | Trismegistos ID  | a     |
    And I press "Save"
    Then I should not see "Your Papyrus record has been created."
    And I should see "Mqt number has already been taken"
    And I should see the following fields with errors
      | field           | message                                                   |
      | MQT Number      | Mqt number has already been taken                         |
      | Trismegistos ID | Trismegistos ID is not a number                           |

  Scenario: Clicking cancel on the create page should take you to the list papyri page
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    Then I follow "Create Papyrus"
    And I follow "Cancel"
    Then I should be on the list papyri page

  Scenario: Editing a Papyrus record (logged in as researcher)
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "MQT 2" papyrus page
    Then I should not see link "Edit this record"
    When I am on the "MQT 2" edit papyrus page
    Then I should be on the home page
    And I should see "You are not authorized to access this page"


  Scenario: Editing a Papyrus record (not logged in)
    Given I am on the "MQT 2" papyrus page
    Then I should not see link "Edit this record"
    When I am on the "MQT 2" edit papyrus page
    Then I should be on the home page
    And I should see "You are not authorized to access this page"


  Scenario: Editing a Papyrus record (logged in as administrator)
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 2" papyrus page
    When I follow "Edit this record"
    Then I should be on the "MQT 2" edit papyrus page
    Then I should see papyrus fields displayed
      | field                    | value               |
      | MQT Number               | 2                   |
      | MQT Note                 | note too            |
      | Inventory ID             | p.macq2             |
      | Languages                | Coptic, Greek       |
      | Dimensions               | 5 x 6 cm            |
      | Date From                | 88 CE               |
      | Date To                  |                     |
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
      | MQT Number               | 6                         |
      | MQT Note                 | none                      |
      | Inventory ID             | 24gac                     |
      | Dimensions               | (a) 2x3cm, (b) 3x3cm      |
      | Date From                | 234 CE                    |
      | Date To                  | 235 CE                    |
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
      | MQT Number               | MQT 6                     |
      | MQT Note                 | none                      |
      | Inventory ID             | 24gac                     |
      | Languages                | Egyptian, Latin           |
      | Dimensions               | (a) 2x3cm, (b) 3x3cm      |
      | Date                     | 234 CE - 235 CE           |
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
    And I should be on the "MQT 6" papyrus page

  Scenario: Editing a Papyrus record and unchecking all languages (logged in as administrator)
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 2" papyrus page
    When I follow "Edit this record"
    Then I should be on the "MQT 2" edit papyrus page
    Then I should see papyrus fields displayed
      | field                    | value               |
      | MQT Number               | 2                   |
      | MQT Note                 | note too            |
      | Inventory ID             | p.macq2             |
      | Languages                | Coptic, Greek       |
      | Dimensions               | 5 x 6 cm            |
      | Date From                | 88 CE               |
      | Date To                  |                     |
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
    And I should be on the "MQT 2" papyrus page
    And I should see the following papyrus details
      | field     | value |
      | Languages |       |

  Scenario: Failing edit of papyrus record
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 2" papyrus page
    When I follow "Edit this record"
    Then I should be on the "MQT 2" edit papyrus page
    When I enter the following papyrus details
      | field     | value |
      | Date From | 0 CE  |
    And I press "Save"
    Then I should not see "Papyrus was successfully updated."
    And I should see "Date from must not be zero"

  Scenario: clicking cancel on the edit page takes you back to the view page for that papyrus
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 2" papyrus page
    When I follow "Edit this record"
    And I follow "Cancel"
    Then I should be on the "MQT 2" papyrus page

  Scenario: clicking cancel should dismiss any changes
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 2" papyrus page
    When I follow "Edit this record"
    And I enter the following papyrus details
      | field      | value      |
      | recto_note | Sponge-bob |
    And I follow "Cancel"
    Then I should not see "Sponge-bob"
    And I should see "Rectangle"

  Scenario: Date field can be blank on edit
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    And I follow "Create Papyrus"
    And I enter the following papyrus details
      | field        | value   |
      | MQT Number   | 6       |
    And I press "Save"
    When I follow "Edit this record"
    And I press "Save"
    Then I should see "Papyrus was successfully updated."

  Scenario: Viewing a Papyrus record (logged in as administrator)
    Given I am logged in as "admin@intersect.org.au"
    And I am on the "MQT 3" papyrus page
    Then I should see "Record is hidden"
    And I am on the "MQT 2" papyrus page
    Then I should see "Record is public"
    And I am on the "MQT 4" papyrus page
    Then I should see "Record is visible"

  Scenario: Viewing a Papyrus record (logged in as Researcher)
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "MQT 3" papyrus page
    Then I should not see "Record is hidden"
    And I am on the "MQT 2" papyrus page
    Then I should not see "Record is public"
    And I am on the "MQT 4" papyrus page
    Then I should not see "Record is visible"

  Scenario: Anonymous user should only see public papyri records
    When I am on the "MQT 3" papyrus page
    Then I should be on the home page
    And I should see "You are not authorized to access this page"

    When I am on the "MQT 2" papyrus page
    Then I should be on the "MQT 2" papyrus page
    And I should not see "You are not authorized to access this page"

    When I am on the "MQT 4" papyrus page
    Then I should be on the "MQT 4" papyrus page
    And I should not see "You are not authorized to access this page"

  Scenario: Admin should see a list of all the papyri
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    When I follow "List all papyri records"
    Then I should be on the papyri page
    And I should see the list papyri table
      | MQT Number | Inventory ID | Note           | Country of Origin | Translation |
      | MQT 3      | hidden.macq  | Specific stuff | Turkey            | No          |
      | MQT 2      | p.macq2      | Specific blah  | Greece            | Yes         |
      | MQT 4      | visible.macq | Specific stuff | Turkey            | No          |
    When I follow "MQT 3"
    Then I should be on the "MQT 3" papyrus page
    When I am on the papyri page
    And I follow "MQT 2"
    Then I should be on the "MQT 2" papyrus page
    When I am on the papyri page
    And I follow "MQT 4"
    Then I should be on the "MQT 4" papyrus page

  Scenario: Researcher should see list of visible and public papyri
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the home page
    When I follow "List all papyri records"
    Then I should be on the papyri page
    And I should see the list papyri table
      | MQT Number | Inventory ID | Note           | Country of Origin | Translation |
      | MQT 3      | hidden.macq  | Specific stuff | Turkey            | No          |
      | MQT 2      | p.macq2      | Specific blah  | Greece            | Yes         |
      | MQT 4      | visible.macq | Specific stuff | Turkey            | No          |

  Scenario: Anonymous user should see list of visible and public papyri
    Given I am on the home page
    When I follow "List all papyri records"
    Then I should be on the papyri page
    And I should see the list papyri table
      | MQT Number | Inventory ID | Note           | Country of Origin | Translation |
      | MQT 2      | p.macq2      | Specific blah  | Greece            | Yes         |
      | MQT 4      | visible.macq | Specific stuff | Turkey            | No          |


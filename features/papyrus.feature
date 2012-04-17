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
    And I have a papyrus
      | mqt_number | mqt_note | inventory_id | apis_id  | trismegistos_id | physical_location | languages     | dimensions             | date_from | date_note | general_note | lines_of_text | paleographic_description | recto_verso_note | origin_details | source_of_acquisition | preservation_note | conservation_note | genre   | language_note | summary             | original_text            | translated_text | other_characteristics | material | type_of_text | modern_textual_dates | publications | visibility |
      | 2          | note too | p.macq2      |          |                 |                   | Coptic, Greek | 5 x 6 cm               | 88 CE     | some date | General Blah | Specific blah | Paleo Diet               | Rectangle        | It's Greek.    | Got it from Greece    | poorly preserved  | conservative      | Book    | Fancy Greek   | don't understand it | περιοχής                 | area            | some other            | fabric   | text type    | some dates           | some pub'ns  | PUBLIC     |
    And I have papyri
      | mqt_number | inventory_id | languages       | dimensions     | date_from   | general_note  | lines_of_text  | visibility |
      | 3          | hidden.macq  | Coptic, Demotic | 5 x 7 cm       | 488 CE      | General stuff | Specific stuff | HIDDEN     |
      | 4          | visible.macq | Coptic, Demotic | 5 x 8 cm       | 488 CE      | General stuff | Specific stuff | VISIBLE    |

  Scenario: no era
    Given I am logged in as "admin@intersect.org.au"
    And I am on the new papyrus page
    When I enter the following papyrus details
      | field      | value |
      | MQT Number | 9     |
      | Date From  | 23    |
      | Date To    | 234   |
    And I press "Save"
    Then I should not see "Your Papyrus record has been created."
    And I should see "Fill in Date From Era"
    And I should see "Fill in Date To Era"

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
      | Physical location        |       |
      | Languages                |       |
      | Dimensions               |       |
      | Material                 |       |
      | Date From                |       |
      | Date To                  |       |
      | Date Note                |       |
      | General Note             |       |
      | Lines of Text            |       |
      | Paleographic Description |       |
      | Recto Verso Note         |       |
      | Material                 |       |
      | Type of Text             |       |
      | Modern Textual Dates     |       |
      | Publications             |       |
      | Origin Details           |       |
      | Source of Acquisition    |       |
      | Preservation Note        |       |
      | Conservation Note        |       |
      | Genre                    |       |
      | Language Note            |       |
      | Summary                  |       |
      | Original Text            |       |
      | Translated Text          |       |
      | Other Characteristics    |       |

    When I enter the following papyrus details
      | field                    | value                     |
      | MQT Number               | 5                         |
      | MQT Note                 | from #2                   |
      | Inventory ID             | 24gac                     |
      | APIS ID                  | P1234                     |
      | Trismegistos ID          | 12345                     |
      | Physical location        | Cabinet A, shelf 3, N.4   |
      | Languages                | Greek, Coptic             |
      | Dimensions               | (a) 2 x 3cm, (b) same     |
      | Date From                | 234 BCE                   |
      | Date To                  | 233 CE                    |
      | Date Note                | special note              |
      | General Note             | this is a papyrus         |
      | Lines of Text            | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Verso Note         | it's shiny                |
      | Material                 | new fabric                |
      | Type of Text             | new type                  |
      | Modern Textual Dates     | new dates                 |
      | Publications             | new pub'ns                |
      | Origin Details           | greece                    |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Conservation Note        | it is conserved           |
      | Genre                    | Letter                    |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |
      | Other Characteristics    | other                     |

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
      | Physical location        | Cabinet A, shelf 3, N.4   |
      | Languages                | Coptic, Greek             |
      | Dimensions               | (a) 2 x 3cm, (b) same     |
      | Date                     | 234 BCE - 233 CE          |
      | Date Note                | special note              |
      | General Note             | this is a papyrus         |
      | Lines of Text            | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Verso Note         | it's shiny                |
      | Type of Text             | new type                  |
      | Modern Textual Dates     | new dates                 |
      | Publications             | new pub'ns                |
      | Material                 | new fabric                |
      | Origin Details           | greece                    |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Conservation Note        | it is conserved           |
      | Genre                    | Letter                    |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |
      | Other Characteristics    | other                     |
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
      | Physical location        |       |
      | Languages                |       |
      | Dimensions               |       |
      | Date                     |       |
      | Date Note                |       |
      | General Note             |       |
      | Lines of Text            |       |
      | Paleographic Description |       |
      | Recto Verso Note         |       |
      | Material                 |       |
      | Type of Text             |       |
      | Modern Textual Dates     |       |
      | Publications             |       |
      | Origin Details           |       |
      | Source of Acquisition    |       |
      | Preservation Note        |       |
      | Conservation Note        |       |
      | Genre                    |       |
      | Language Note            |       |
      | Summary                  |       |
      | Original Text            |       |
      | Translated Text          |       |
      | Other Characteristics    |       |

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
      | APIS ID                  |                     |
      | Trismegistos ID          |                     |
      | Physical location        |                     |
      | Languages                | Coptic, Greek       |
      | Dimensions               | 5 x 6 cm            |
      | Date From                | 88 CE               |
      | Date To                  |                     |
      | Date Note                | some date           |
      | General Note             | General Blah        |
      | Lines of Text            | Specific blah       |
      | Paleographic Description | Paleo Diet          |
      | Recto Verso Note         | Rectangle           |
      | Material                 | fabric              |
      | Type of Text             | text type           |
      | Modern Textual Dates     | some dates          |
      | Publications             | some pub'ns         |
      | Origin Details           | It's Greek.         |
      | Source of Acquisition    | Got it from Greece  |
      | Preservation Note        | poorly preserved    |
      | Conservation Note        | conservative        |
      | Genre                    | Book                |
      | Language Note            | Fancy Greek         |
      | Summary                  | don't understand it |
      | Original Text            | περιοχής            |
      | Translated Text          | area                |
      | Other Characteristics    | some other          |
    When I enter the following papyrus details
      | field                    | value                     |
      | MQT Number               | 6                         |
      | MQT Note                 | none                      |
      | Inventory ID             | 24gac                     |
      | APIS ID                  | apis.1                    |
      | Trismegistos ID          | 123                       |
      | Physical location        | cabinet 12                |
      | Dimensions               | (a) 2x3cm, (b) 3x3cm      |
      | Date From                | 234 CE                    |
      | Date To                  | 235 CE                    |
      | Date Note                | special date note         |
      | General Note             | this is a papyrus         |
      | Lines of Text            | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Verso Note         | it's shiny                |
      | Material                 | skin                      |
      | Type of Text             | a type                    |
      | Modern Textual Dates     | a date                    |
      | Publications             | publicat                  |
      | Origin Details           | Turkish                   |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Conservation Note        | conserved again           |
      | Genre                    | Letter                    |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |
      | Other Characteristics    | other new                 |
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
      | APIS ID                  | apis.1                    |
      | Trismegistos ID          | 123                       |
      | Physical location        | cabinet 12                |
      | Languages                | Egyptian, Latin           |
      | Dimensions               | (a) 2x3cm, (b) 3x3cm      |
      | Date                     | 234 CE - 235 CE           |
      | Date Note                | special date note         |
      | General Note             | this is a papyrus         |
      | Lines of Text            | same as general           |
      | Paleographic Description | sydney                    |
      | Recto Verso Note         | it's shiny                |
      | Type of Text             | a type                    |
      | Modern Textual Dates     | a date                    |
      | Material                 | skin                      |
      | Publications             | publicat                  |
      | Origin Details           | Turkish                   |
      | Source of Acquisition    | shady dealer              |
      | Preservation Note        | do not get wet            |
      | Conservation Note        | conserved again           |
      | Genre                    | Letter                    |
      | Language Note            | it's in greek             |
      | Summary                  | very old papyrus          |
      | Original Text            | περιοχής για να τιμήσουμε |
      | Translated Text          | area to honor             |
      | Other Characteristics    | other new                 |
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
      | APIS ID                  |                     |
      | Trismegistos ID          |                     |
      | Physical location        |                     |
      | Languages                | Coptic, Greek       |
      | Dimensions               | 5 x 6 cm            |
      | Date From                | 88 CE               |
      | Date To                  |                     |
      | Date Note                | some date           |
      | General Note             | General Blah        |
      | Lines of Text            | Specific blah       |
      | Paleographic Description | Paleo Diet          |
      | Recto Verso Note         | Rectangle           |
      | Material                 | fabric              |
      | Type of Text             | text type           |
      | Modern Textual Dates     | some dates          |
      | Publications             | some pub'ns         |
      | Origin Details           | It's Greek.         |
      | Source of Acquisition    | Got it from Greece  |
      | Preservation Note        | poorly preserved    |
      | Conservation Note        | conservative        |
      | Genre                    | Book                |
      | Language Note            | Fancy Greek         |
      | Summary                  | don't understand it |
      | Original Text            | περιοχής            |
      | Translated Text          | area                |
      | Other Characteristics    | some other          |
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
      | field            | value      |
      | recto_verso_note | Sponge-bob |
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

  Scenario: as admin I should see all fields for all visibilities
    Given I am logged in as "admin@intersect.org.au"
    And I have papyri
      | mqt_number | mqt_note | inventory_id | apis_id  | trismegistos_id | physical_location | languages     | dimensions             | date_from | date_note | general_note | lines_of_text | paleographic_description | recto_verso_note | origin_details | source_of_acquisition | preservation_note | conservation_note | genre   | language_note | summary             | original_text            | translated_text | other_characteristics | material | type_of_text | modern_textual_dates | publications | visibility |
      | 7          | note too | p.macq7      | APIS.7   | 77              | Physical 7        | Coptic, Greek | (a) 2 x 7cm, (b) same  | 237 BCE   | date 7    | general 7    | lines 7       | paleo 7                  | recto verso 7    | Greek seven    | Got it 7              | minus 7           | taped to 7        | Book    | greek 7       | very seven papyrus  | περιοχής για 7 τιμήσουμε | area 7          | other 7               | fabric   | text type    | date at 7            | pub.mq.7     | HIDDEN     |
      | 8          | note too | p.macq8      | APIS.8   | 88              | Physical 8        | Coptic, Greek | (a) 2 x 8cm, (b) same  | 238 BCE   | date 8    | general 8    | lines 8       | paleo 8                  | recto verso 8    | Greek seven    | Got it 8              | minus 8           | taped to 8        | Book    | greek 8       | very seven papyrus  | περιοχής για 8 τιμήσουμε | area 8          | other 8               | fabric   | text type    | date at 8            | pub.mq.8     | PUBLIC     |
      | 9          | note too | p.macq9      | APIS.9   | 99              | Physical 9        | Coptic, Greek | (a) 2 x 9cm, (b) same  | 239 BCE   | date 9    | general 9    | lines 9       | paleo 9                  | recto verso 9    | Greek seven    | Got it 9              | minus 9           | taped to 9        | Book    | greek 9       | very seven papyrus  | περιοχής για 9 τιμήσουμε | area 9          | other 9               | fabric   | text type    | date at 9            | pub.mq.9     | VISIBLE    |
    And I am on the "MQT 7" papyrus page
    Then I should see "Record is hidden"
    And I should see the following papyrus details
      | field                    | value                     |
      | MQT Number               | MQT 7                     |
      | MQT Note                 | note too                  |
      | Inventory ID             | p.macq7                   |
      | APIS ID                  | APIS.7                    |
      | Trismegistos ID          | 77                        |
      | Physical location        | Physical 7                |
      | Languages                | Coptic, Greek             |
      | Dimensions               | (a) 2 x 7cm, (b) same     |
      | Date                     | 237 BCE                   |
      | Date Note                | date 7                    |
      | General Note             | general 7                 |
      | Lines of Text            | lines 7                   |
      | Paleographic Description | paleo 7                   |
      | Recto Verso Note         | recto verso 7             |
      | Type of Text             | text type                 |
      | Modern Textual Dates     | date at 7                 |
      | Publications             | pub.mq.7                  |
      | Material                 | fabric                    |
      | Origin Details           | Greek seven               |
      | Source of Acquisition    | Got it 7                  |
      | Preservation Note        | minus 7                   |
      | Conservation Note        | taped to 7                |
      | Genre                    | Book                      |
      | Language Note            | greek 7                   |
      | Summary                  | very seven papyrus        |
      | Original Text            | περιοχής για 7 τιμήσουμε  |
      | Translated Text          | area 7                    |
      | Other Characteristics    | other 7                   |
    And I am on the "MQT 8" papyrus page
    Then I should see "Record is public"
    And I should see the following papyrus details
      | field                    | value                     |
      | MQT Number               | MQT 8                     |
      | MQT Note                 | note too                  |
      | Inventory ID             | p.macq8                   |
      | APIS ID                  | APIS.8                    |
      | Trismegistos ID          | 88                        |
      | Physical location        | Physical 8                |
      | Languages                | Coptic, Greek             |
      | Dimensions               | (a) 2 x 8cm, (b) same     |
      | Date                     | 238 BCE                   |
      | Date Note                | date 8                    |
      | General Note             | general 8                 |
      | Lines of Text            | lines 8                   |
      | Paleographic Description | paleo 8                   |
      | Recto Verso Note         | recto verso 8             |
      | Type of Text             | text type                 |
      | Modern Textual Dates     | date at 8                 |
      | Publications             | pub.mq.8                  |
      | Material                 | fabric                    |
      | Origin Details           | Greek seven               |
      | Source of Acquisition    | Got it 8                  |
      | Preservation Note        | minus 8                   |
      | Conservation Note        | taped to 8                |
      | Genre                    | Book                      |
      | Language Note            | greek 8                   |
      | Summary                  | very seven papyrus        |
      | Original Text            | περιοχής για 8 τιμήσουμε  |
      | Translated Text          | area 8                    |
      | Other Characteristics    | other 8                   |
    And I am on the "MQT 9" papyrus page
    Then I should see "Record is visible"
    And I should see the following papyrus details
      | field                    | value                     |
      | MQT Number               | MQT 9                     |
      | MQT Note                 | note too                  |
      | Inventory ID             | p.macq9                   |
      | APIS ID                  | APIS.9                    |
      | Trismegistos ID          | 99                        |
      | Physical location        | Physical 9                |
      | Languages                | Coptic, Greek             |
      | Dimensions               | (a) 2 x 9cm, (b) same     |
      | Date                     | 239 BCE                   |
      | Date Note                | date 9                    |
      | General Note             | general 9                 |
      | Lines of Text            | lines 9                   |
      | Paleographic Description | paleo 9                   |
      | Recto Verso Note         | recto verso 9             |
      | Type of Text             | text type                 |
      | Modern Textual Dates     | date at 9                 |
      | Publications             | pub.mq.9                  |
      | Material                 | fabric                    |
      | Origin Details           | Greek seven               |
      | Source of Acquisition    | Got it 9                  |
      | Preservation Note        | minus 9                   |
      | Conservation Note        | taped to 9                |
      | Genre                    | Book                      |
      | Language Note            | greek 9                   |
      | Summary                  | very seven papyrus        |
      | Original Text            | περιοχής για 9 τιμήσουμε  |
      | Translated Text          | area 9                    |
      | Other Characteristics    | other 9                   |



  Scenario: as a researcher I should only see fields that I am entitled to see
    Given I am logged in as "researcher@intersect.org.au"
    And I have a papyrus
      | mqt_number | mqt_note | inventory_id | apis_id  | trismegistos_id | physical_location | languages     | dimensions             | date_from | date_note | general_note | lines_of_text | paleographic_description | recto_verso_note | origin_details | source_of_acquisition | preservation_note | conservation_note | genre   | language_note | summary             | original_text            | translated_text | other_characteristics | material | type_of_text | modern_textual_dates | publications | visibility |
      | 7          | note too | p.macq7      | APIS.7   | 77              | Physical 7        | Coptic, Greek | (a) 2 x 7cm, (b) same  | 237 BCE   | date 7    | general 7    | lines 7       | paleo 7                  | recto verso 7    | Greek seven    | Got it 7              | minus 7           | taped to 7        | Book    | greek 7       | very seven papyrus  | περιοχής για 7 τιμήσουμε | area 7          | other 7               | fabric   | text type    | date at 7            | pub.mq.7     | HIDDEN     |
      | 8          | note too | p.macq8      | APIS.8   | 88              | Physical 8        | Coptic, Greek | (a) 2 x 8cm, (b) same  | 238 BCE   | date 8    | general 8    | lines 8       | paleo 8                  | recto verso 8    | Greek seven    | Got it 8              | minus 8           | taped to 8        | Book    | greek 8       | very seven papyrus  | περιοχής για 8 τιμήσουμε | area 8          | other 8               | fabric   | text type    | date at 8            | pub.mq.8     | PUBLIC     |
      | 9          | note too | p.macq9      | APIS.9   | 99              | Physical 9        | Coptic, Greek | (a) 2 x 9cm, (b) same  | 239 BCE   | date 9    | general 9    | lines 9       | paleo 9                  | recto verso 9    | Greek seven    | Got it 9              | minus 9           | taped to 9        | Book    | greek 9       | very seven papyrus  | περιοχής για 9 τιμήσουμε | area 9          | other 9               | fabric   | text type    | date at 9            | pub.mq.9     | VISIBLE    |
      | 10         | note too | p.macq10     | APIS.10  | 910             | Physical 10       | Coptic, Greek | (a) 2 x 9cm, (b) same  | 231 BCE   | date 10   | general 10   | lines 10      | paleo 10                 | recto verso 10   | Greek seven    | Got it 10             | minus 10          | taped to 10       | Book    | greek 10      | very seven papyrus  | περιοχής για 10τιμήσουμε | area 10         | other 10              | fabric   | text type    | date at 10           | pub.mq.10    | VISIBLE    |
    And I have papyrus access requests
      | User requesting access        | MQT Number | Date requested | Date approved |
      | researcher@intersect.org.au   | 10         | 2012-01-01     | 2012-01-02    |
    And I am on the "MQT 7" papyrus page
    Then I should see the following papyrus details
      | field                    | value                     |
      | MQT Number               | MQT 7                     |
      | Inventory ID             | p.macq7                   |
      | APIS ID                  | APIS.7                    |
      | Trismegistos ID          | 77                        |
      | Physical location        | Physical 7                |
      | Languages                | Coptic, Greek             |
      | Dimensions               | (a) 2 x 7cm, (b) same     |
      | Date                     | 237 BCE                   |
      | Date Note                | date 7                    |
      | General Note             | general 7                 |
      | Lines of Text            | lines 7                   |
      | Paleographic Description | paleo 7                   |
      | Type of Text             | text type                 |
      | Publications             | pub.mq.7                  |
      | Material                 | fabric                    |
      | Origin Details           | Greek seven               |
      | Source of Acquisition    | Got it 7                  |
      | Preservation Note        | minus 7                   |
      | Conservation Note        | taped to 7                |
      | Genre                    | Book                      |
      | Language Note            | greek 7                   |
      | Summary                  | very seven papyrus        |
      | Translated Text          | area 7                    |
      | Other Characteristics    | other 7                   |
    And I should not see the following papyrus details
      | field                    | value                     |
      | MQT Note                 | note too                  |
      | Recto Verso Note         | recto verso 7             |
      | Modern Textual Dates     | date at 7                 |
    And I am on the "MQT 8" papyrus page
    And I should see the following papyrus details
      | field                    | value                     |
      | MQT Number               | MQT 8                     |
      | MQT Note                 | note too                  |
      | Inventory ID             | p.macq8                   |
      | APIS ID                  | APIS.8                    |
      | Trismegistos ID          | 88                        |
      | Physical location        | Physical 8                |
      | Languages                | Coptic, Greek             |
      | Dimensions               | (a) 2 x 8cm, (b) same     |
      | Date                     | 238 BCE                   |
      | Date Note                | date 8                    |
      | General Note             | general 8                 |
      | Lines of Text            | lines 8                   |
      | Paleographic Description | paleo 8                   |
      | Recto Verso Note         | recto verso 8             |
      | Type of Text             | text type                 |
      | Modern Textual Dates     | date at 8                 |
      | Publications             | pub.mq.8                  |
      | Material                 | fabric                    |
      | Origin Details           | Greek seven               |
      | Source of Acquisition    | Got it 8                  |
      | Preservation Note        | minus 8                   |
      | Conservation Note        | taped to 8                |
      | Genre                    | Book                      |
      | Language Note            | greek 8                   |
      | Summary                  | very seven papyrus        |
      | Original Text            | περιοχής για 8 τιμήσουμε  |
      | Translated Text          | area 8                    |
      | Other Characteristics    | other 8                   |
    And I am on the "MQT 9" papyrus page
    Then I should see the following papyrus details
      | field                    | value                     |
      | MQT Number               | MQT 9                     |
      | Inventory ID             | p.macq9                   |
      | APIS ID                  | APIS.9                    |
      | Trismegistos ID          | 99                        |
      | Physical location        | Physical 9                |
      | Languages                | Coptic, Greek             |
      | Dimensions               | (a) 2 x 9cm, (b) same     |
      | Date                     | 239 BCE                   |
      | Date Note                | date 9                    |
      | General Note             | general 9                 |
      | Lines of Text            | lines 9                   |
      | Paleographic Description | paleo 9                   |
      | Type of Text             | text type                 |
      | Publications             | pub.mq.9                  |
      | Material                 | fabric                    |
      | Origin Details           | Greek seven               |
      | Source of Acquisition    | Got it 9                  |
      | Preservation Note        | minus 9                   |
      | Conservation Note        | taped to 9                |
      | Genre                    | Book                      |
      | Language Note            | greek 9                   |
      | Summary                  | very seven papyrus        |
      | Translated Text          | area 9                    |
      | Other Characteristics    | other 9                   |
    And I should not see the following papyrus details
      | field                    | value                     |
      | MQT Note                 | note too                  |
      | Recto Verso Note         | recto verso 9             |
      | Modern Textual Dates     | date at 9                 |
    And I am on the "MQT 10" papyrus page
    And I should see the following papyrus details
      | field                    | value                     |
      | MQT Number               | MQT 10                    |
      | MQT Note                 | note too                  |
      | Inventory ID             | p.macq10                  |
      | APIS ID                  | APIS.10                   |
      | Trismegistos ID          | 910                       |
      | Physical location        | Physical 10               |
      | Languages                | Coptic, Greek             |
      | Dimensions               | (a) 2 x 9cm, (b) same     |
      | Date                     | 231 BCE                   |
      | Date Note                | date 10                   |
      | General Note             | general 10                |
      | Lines of Text            | lines 10                  |
      | Paleographic Description | paleo 10                  |
      | Recto Verso Note         | recto verso 10            |
      | Type of Text             | text type                 |
      | Modern Textual Dates     | date at 10                |
      | Publications             | pub.mq.10                 |
      | Material                 | fabric                    |
      | Origin Details           | Greek seven               |
      | Source of Acquisition    | Got it 10                 |
      | Preservation Note        | minus 10                  |
      | Conservation Note        | taped to 10               |
      | Genre                    | Book                      |
      | Language Note            | greek 10                  |
      | Summary                  | very seven papyrus        |
      | Original Text            | περιοχής για 10τιμήσουμε  |
      | Translated Text          | area 10                   |
      | Other Characteristics    | other 10                  |

  Scenario: Viewing a Papyrus record (logged in as Researcher)
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "MQT 3" papyrus page
    Then I should not see "Record is hidden"
    And I am on the "MQT 2" papyrus page
    Then I should not see "Record is public"
    And I am on the "MQT 4" papyrus page
    Then I should not see "Record is visible"

  Scenario: a researcher can only see detailed fields for not-granted access records
    Given I am logged in as "researcher@intersect.org.au"
    And I am on the "MQT 3" papyrus page
    Then I should not see "Record is hidden"


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
      | MQT Number | Inventory ID | Lines of Text  | Translation |
      | MQT 3      | hidden.macq  | Specific stuff | No          |
      | MQT 2      | p.macq2      | Specific blah  | Yes         |
      | MQT 4      | visible.macq | Specific stuff | No          |
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
      | MQT Number | Inventory ID | Lines of Text  | Translation |
      | MQT 3      | hidden.macq  | Specific stuff | No          |
      | MQT 2      | p.macq2      | Specific blah  | Yes         |
      | MQT 4      | visible.macq | Specific stuff | No          |

  Scenario: Anonymous user should see list of visible and public papyri
    Given I am on the home page
    When I follow "List all papyri records"
    Then I should be on the papyri page
    And I should see the list papyri table
      | MQT Number | Inventory ID | Lines of Text  | Translation |
      | MQT 2      | p.macq2      | Specific blah  | Yes         |
      | MQT 4      | visible.macq | Specific stuff | No          |


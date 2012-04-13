Feature: In order to associate new images with papyri records
  As an Administrator
  I want to upload images to the papyri records

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
    And I have papyri
      | mqt_number | inventory_id | languages     | dimensions    | date_from | general_note | paleographic_description | recto_verso_note | country_of_origin | origin_details | source_of_acquisition | preservation_note | genre | language_note | summary             | original_text | translated_text | visibility |
      | 2          | p.macq1      | Coptic, Greek | 5 x 6 cm      | 88 CE     | General Blah | Paleo Diet               | Rectangle        | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | PUBLIC     |
      | 3          | hidden       | Coptic, Greek | 5 x 6 cm      | 88 CE     | General Blah | Paleo Diet               | Rectangle        | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | HIDDEN     |
      | 4          | public       | Coptic, Greek | 5 x 6 cm      | 88 CE     | General Blah | Paleo Diet               | Rectangle        | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | PUBLIC     |
      | 5          | visible      | Coptic, Greek | 5 x 6 cm      | 88 CE     | General Blah | Paleo Diet               | Rectangle        | Greece            | It's Greek.    | Got it from Greece    | poorly preserved  | Book  | Fancy Greek   | don't understand it | περιοχής      | area            | VISIBLE    |
    And "admin@intersect.org.au" uploaded image "test.tiff" to "MQT 3" with caption "hidden"
    And "admin@intersect.org.au" uploaded image "test2.tiff" to "MQT 4" with caption "public"
    And "admin@intersect.org.au" uploaded image "test.tiff" to "MQT 5" with caption "visible"

  Scenario: Clicking cancel
    Given I am logged in as "admin@intersect.org.au"
    And I am on the upload image page for "MQT 2"
    When I follow "Cancel"
    Then I should be on the "MQT 2" papyrus page

  Scenario: Add image without caption
    Given I am logged in as "admin@intersect.org.au"
    And I am on the upload image page for "MQT 2"
    When I attach image "test.tiff"
    And I press "Upload"
    Then I should not see "Your image was successfully uploaded."
    And I should see "Caption can't be blank"

  Scenario: Add image without image
    Given I am logged in as "admin@intersect.org.au"
    And I am on the upload image page for "MQT 2"
    When I fill in "Caption" with "some caption"
    And I press "Upload"
    Then I should not see "Your image was successfully uploaded."
    And I should see "Image can't be blank"

  Scenario: Uploading an image
    Given I am logged in as "admin@intersect.org.au"
    When I am on the "MQT 2" papyrus page
    Then I should see "Upload"
    When I follow "Upload"
    Then I should be on the upload image page for "MQT 2"
    When I attach image "test.tiff"
    And I fill in "Caption" with "This is my fancy picture"
    And I press "Upload"
    Then I should be on the "MQT 2" papyrus page
    Then I should see "Your image was successfully uploaded."
    And "MQT 2" should have 1 image
    And I should see low res image for "test.tiff" of papyrus "MQT 2"
    When I am on the papyrus "MQT 2" image "test.tiff" "low_res" page
    Then I should not see "You are not authorized to access this page."
    When I am on the "MQT 2" papyrus page
    Then I should see "Download in high resolution" for "test.tiff" for "MQT 2"
    And I should see "This is my fancy picture"
    When I follow "Download in high resolution" for "test.tiff" for "MQT 2"
    Then I should not see "You are not authorized to access this page."

  Scenario: researcher can't upload
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the "MQT 5" papyrus page
    Then I should not see "Upload"
    When I am on the upload image page for "MQT 5"
    Then I should be on the home page
    And I should see "You are not authorized to access this page."

  Scenario: anonymous user can't upload
    When I am on the "MQT 5" papyrus page
    Then I should not see "Upload"
    When I am on the upload image page for "MQT 5"
    Then I should be on the home page
    And I should see "You are not authorized to access this page."

  Scenario Outline: Anonymous can't download high res image of HIDDEN or VISIBLE
    When I am on the "MQT <mqt_number>" papyrus page
    Then I should not see "Download in high resolution" for "<filename>" for "MQT <mqt_number>"
    When I am on the papyrus "MQT <mqt_number>" image "<filename>" "original" page
    Then I should see "You are not authorized to access this page."
  Examples:
    | mqt_number | filename  |
    | 3          | test.tiff |
    | 5          | test.tiff |

  Scenario Outline: researcher can't download high res image of HIDDEN or VISIBLE
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the "MQT <mqt_number>" papyrus page
    Then I should not see "Download in high resolution" for "<filename>" for "MQT <mqt_number>"
    When I am on the papyrus "MQT <mqt_number>" image "<filename>" "original" page
    Then I should see "You are not authorized to access this page."
  Examples:
    | mqt_number | filename  |
    | 3          | test.tiff |
    | 5          | test.tiff |

  Scenario: Anonymous can download high res image of PUBLIC
    Given I am on the "MQT 4" papyrus page
    Then I should see "Download in high resolution" for "test2.tiff" for "MQT 4"
    When I follow "Download in high resolution" for "test2.tiff" for "MQT 4"
    Then I should not see "You are not authorized to access this page."

  Scenario: Researcher can download high res image of PUBLIC
    Given I am logged in as "researcher@intersect.org.au"
    When I am on the "MQT 4" papyrus page
    Then I should see "Download in high resolution" for "test2.tiff" for "MQT 4"
    When I follow "Download in high resolution" for "test2.tiff" for "MQT 4"
    Then I should not see "You are not authorized to access this page."

  Scenario Outline: Anonymous users can download public & visible low res images
    Given I am on the "MQT <mqt_number>" papyrus page
    Then I should see "Download in low resolution" for "<image>" for "MQT <mqt_number>"
    When I follow "Download in low resolution" for "<image>" for "MQT <mqt_number>"
    Then I should not see "You are not authorized to access this page."
  Examples:
    | mqt_number | image      |
    | 4          | test2.tiff |
    | 5          | test.tiff  |

  Scenario: Anonymous users can't download low res images for hidden papyrus records
    Given I am on the "MQT 3" papyrus page
    Then I should see "You are not authorized to access this page."

  Scenario Outline: researchers & admin users can download all low res images
    Given I am logged in as "<username>@intersect.org.au"
    Given I am on the "MQT <mqt_number>" papyrus page
    Then I should see "Download in low resolution" for "<image>" for "MQT <mqt_number>"
    When I follow "Download in low resolution" for "<image>" for "MQT <mqt_number>"
    Then I should not see "You are not authorized to access this page."
  Examples:
    | username   | mqt_number | image      |
    | admin      | 4          | test2.tiff |
    | admin      | 5          | test.tiff  |
    | admin      | 3          | test.tiff  |
    | researcher | 4          | test2.tiff |
    | researcher | 5          | test.tiff  |
    | researcher | 3          | test.tiff  |


